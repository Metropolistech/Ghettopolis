class AddLastnameAndFirstnameToUser < ActiveRecord::Migration
  def up
    add_column :users, :lastname, :string
    add_column :users, :firstname, :string
  end

  def down
    User.find_each do |user|
      user.firstname = user.username
      user.lastname = user.username
      user.save
    end
  end
end
