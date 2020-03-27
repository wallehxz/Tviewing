class CreateUserActionLogs < ActiveRecord::Migration
  def change
    create_table :user_action_logs do |t|
      t.integer :user_id
      t.string :action
      t.string :result
      t.string :ip
      t.string :location

      t.timestamps null: false
    end
  end
end
