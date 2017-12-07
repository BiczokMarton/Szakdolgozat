class AddFollowsToUser < ActiveRecord::Migration[5.1]
  def self.up
  	add_column :users, :follows, :string, array: true
  end

  def self.down
    remove_column :users, :follows
  end
end
