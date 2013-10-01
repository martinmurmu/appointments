class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :title
      t.text :description
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
