class Repo < ActiveRecord::Base
  attr_accessible :description, :forks, :issues, :language, :last_commit_sha, :name, :owner, :watchers
end
