class AddConsumerIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :consumer_id, :integer
  end
end
