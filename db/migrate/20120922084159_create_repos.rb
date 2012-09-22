class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :owner
      t.text :language
      t.integer :forks
      t.integer :issues
      t.integer :watchers
      t.string :description
      t.string :last_commit_sha

      t.timestamps
    end
  end
end
