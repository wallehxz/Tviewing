class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.string :key
      t.string :size
      t.string :mine_type
      t.string :md5_value
      t.datetime :upload_at
    end
  end
end
