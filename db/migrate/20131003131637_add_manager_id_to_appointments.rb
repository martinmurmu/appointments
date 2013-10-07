class AddManagerIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :manager_id, :integer
  end
end
