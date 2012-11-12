class AddNewResultsPresenceToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :new_results_presence, :boolean, default: false
  end
end
