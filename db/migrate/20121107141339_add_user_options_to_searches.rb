class AddUserOptionsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :user_id,     :integer, null: false
    add_column :searches, :saved,       :boolean, null: false, default: false
    add_column :searches, :notified,    :boolean, null: false, default: false
    add_column :searches, :notified_at, :timestamp
  end
end
