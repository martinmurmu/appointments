class AddEnabledToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :enabled, :boolean, :default => true
  end
end
