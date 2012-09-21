class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :login
      t.string  :name
      t.string  :location
      t.string  :email
      t.string  :type
      t.string  :blog
      t.string  :avatar_url
      t.string  :company
      t.text    :repos
      t.integer :following
      t.integer :followers
      t.integer :public_repos
      t.integer :public_gists

      t.timestamps
    end
  end
end
