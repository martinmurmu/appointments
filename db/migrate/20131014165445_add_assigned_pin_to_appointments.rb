class AddAssignedPinToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :assigned_pin, :string, :null => true
  end
end
