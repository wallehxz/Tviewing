class AddAvatarToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :avatar, :string, default:''
  end
end
