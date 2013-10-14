class AddStatusToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :status, :string, :null => true, :default => "open"
  end
end
