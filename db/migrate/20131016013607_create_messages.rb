class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sms_sid, :null => false, :unique => true
      t.integer :manager_id, :null => false
      t.integer :consumer_id, :null => false
      t.timestamps
    end
  end
end
