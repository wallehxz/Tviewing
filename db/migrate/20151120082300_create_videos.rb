class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :column_id
      t.string  :url_code
      t.integer :recommend, default: 0
      t.integer :video_type
      t.string  :video_url, null:false
      t.string  :title
      t.string  :cover
      t.string  :duration
      t.text    :summary
      t.integer :view_count, :integer, default:0, limit:8

      t.timestamps null: false
    end

    add_index :videos, :url_code,  unique: true
  end
end
