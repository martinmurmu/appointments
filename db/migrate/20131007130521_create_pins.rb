class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :pin, :null => false, :unique => true
      t.integer :appointment_id, :null => false
      t.integer :consumer_id, :null => false
      t.timestamps
    end
  end
end
