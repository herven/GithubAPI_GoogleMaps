class AddingFieldToUser < ActiveRecord::Migration
  def up
    add_column :users, :latitude,  :float
    add_column :users, :longitude, :float
    add_column :users, :gmaps, :boolean
  end

  def down
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :gmaps
  end
end
