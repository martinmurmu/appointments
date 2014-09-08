class ChangeDefaultValueToStatusAppointments < ActiveRecord::Migration
  def up
    change_column :appointments, :status, :string, :default => "Broadcasted"
  end

  def down
    change_column :appointments, :status, :string, :default => "open"
  end
end
