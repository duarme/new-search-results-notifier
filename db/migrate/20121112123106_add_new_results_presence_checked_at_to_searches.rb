class AddNewResultsPresenceCheckedAtToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :new_results_presence_checked_at, :timestamp
  end
end
