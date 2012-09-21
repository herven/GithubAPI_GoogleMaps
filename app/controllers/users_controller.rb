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
    begin
      client = Github.new
      @commits = client.repos.commits.all  params[:user], params[:repo], {:page => 1, :per_page => 100, :branch => 'master'}
      @users_login = []
      @commits.each do |commit|
        @users_login << commit['author']['login'] if commit['author']
      end
      @logins = @users_login.uniq!
      self.find_or_create_user(@logins, client)
      redirect_to show_commiters_users_path(:repo => params[:repo])
    rescue
      redirect_to '/'
    end
  end

  def show_commiters
    @users = User.without_location.by_repo(params[:repo]).all
    @json = User.with_location.by_repo(params[:repo]).to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(:partial => "/users/user", :locals => { :user => user})
      marker.title "#{user.name}"
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

  protected

  def find_or_create_user(logins, client)
    logins.each do |login|
      @user = User.where(:login => login).first
      unless @user
        user_info = client.users.get :user => login
        @user = User.create(:login        => login,
                    :name         => user_info["name"],
                    :location     => user_info["location"].present? ? user_info["location"].split(",").first : 'none',
                    :email        => user_info["email"],
                    :type         => user_info["type"],
                    :blog         => user_info["blog"],
                    :repos        => [ params[:repo] ],
                    :avatar_url   => user_info["avatar_url"],
                    :company      => user_info["company"],
                    :following    => user_info["following"],
                    :followers    => user_info["followers"],
                    :public_repos => user_info["public_repos"],
                    :public_gists => user_info["public_gists"]
        )
      else
        unless @user.repos.include?(params[:repo])
          @user.repos << params[:repo]
          @user.save
        end
      end
    end
  end
end
