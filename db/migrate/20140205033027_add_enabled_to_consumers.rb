class AddEnabledToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :enabled, :boolean, :default => true
  end
end
