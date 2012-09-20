class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def get_commiters
    github = Github.new

    commits = github.repos.commits.all  'rails', 'rails'

    users = []

    commits.each do |commit|
      users << commit['author']['login']
    end
    u = users.uniq
    u.each do |login|
      user = github.users.get :user => login
      logger.info "//////////#{ user['id'] }//////#{user['login']}/////////#{ user["location"] }////////////////////#{ user['email'] }////////////"
      location = user["location"].present? ? user["location"].split(",").first : ''
      User.create(:name => login, :location => location)
    end

    redirect_to show_commiters_users_path
  end

  def show_commiters

    #@json = User.all.to_gmaps4rails

    @users = User.all
    @json = @users.to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(:partial => "/users/infowindow", :locals => { :user => user})
      marker.title "#{user.name}"
      marker.json({ :location => user.location})
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
