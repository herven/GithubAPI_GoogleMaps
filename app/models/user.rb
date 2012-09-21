class User < ActiveRecord::Base
  attr_accessible :login, :name, :location, :email, :type, :blog, :avatar_url, :company, :repos, :following, :followers, :public_repos, :public_gists
  acts_as_gmappable
  serialize :repos, Array

  def gmaps4rails_address
    "#{self.location}"
  end

  scope :with_location, where(" location != 'none' ")
  scope :without_location, where(:location => 'none' )
  scope :by_repo, lambda{|repo| where("repos LIKE '%#{repo}%' ")  }

  def repository(repo)
    self.repos.include?(repo)
  end
end
