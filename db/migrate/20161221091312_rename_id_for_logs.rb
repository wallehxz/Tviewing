class RenameIdForLogs < ActiveRecord::Migration
  def change
    rename_column :user_action_logs, :ip, :local_ip
  end
end
