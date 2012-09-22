class UsersController < ApplicationController
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
      repo = client.repos.get  params[:user], params[:repo] 
      @repo = Repo.where(:name => repo.name).first ? Repo.where(:name => repo.name).first : Repo.create(:name => repo.name, :owner => repo.owner.login, :language => repo.language, :forks => repo.forks, :watchers => repo.watchers, :description => repo.description, :issues => repo.open_issues)
      @commits = client.repos.commits.all  @repo.owner, @repo.name, {:per_page => 100, :sha => @repo.last_commit_sha}
      @repo.update_attribute(:last_commit_sha, @commits.last.sha)
      @users_login = []
      @commits.each do |commit|
        @users_login << commit.author.login if commit.author
      end
      @logins = @users_login.uniq!
      self.find_or_create_user(@logins, client)
      redirect_to show_commiters_users_path(:repo => params[:repo])
    rescue
      redirect_to '/'
    end
  end
  
  def show_commiters
    client = Github.new
    @repo = Repo.where(:name => params[:repo]).first    
    @users = User.without_location.by_repo(@repo.name).all
    @issues = client.issues.list_repo @repo.owner, @repo.name, {:per_page => 10} 
    @collaborators = client.repos.collaborators.list @repo.owner, @repo.name
    @json = User.with_location.by_repo(params[:repo]).to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(:partial => "/users/user", :locals => { :user => user})
      marker.title "#{user.name}"
    end
  end


  protected

  def find_or_create_user(logins, client)
    logins.each do |login|
      @user = User.where(:login => login).first
      unless @user
        user_info = client.users.get :user => login
        @user = User.create(:login        => login,
                    :name         => user_info.name,
                    :location     => user_info['location'].present? ? user_info['location'] : 'none',
                    :email        => user_info.email,
                    :type         => user_info.type,
                    :blog         => user_info.blog,
                    :repos        => [ params[:repo] ],
                    :avatar_url   => user_info.avatar_url,
                    :company      => user_info.company,
                    :following    => user_info.following,
                    :followers    => user_info.followers,
                    :public_repos => user_info.public_repos,
                    :public_gists => user_info.public_gists
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
