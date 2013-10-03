class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :phone_number, :null => false, :default => ""
      t.timestamps
    end
  end
end
