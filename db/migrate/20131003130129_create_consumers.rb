class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :phone_number, :null => false, :default => "", :unique => true
      t.timestamps
    end
  end
end
