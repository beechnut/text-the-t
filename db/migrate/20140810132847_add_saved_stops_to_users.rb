class AddSavedStopsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :saved_stops, :string, array: true, default: '{}'
  end
end
