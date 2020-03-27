class AddVipToVolumns < ActiveRecord::Migration
  def change
    add_column :columns, :vip, :boolean, default: :false
  end
end
