class RenameNotifiedToNotifyInSearches < ActiveRecord::Migration
  def change
    rename_column :searches, :notified, :notify 
  end
end
