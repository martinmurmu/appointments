class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :practice_name, :null => false, :default => ""
      t.string :practice_address, :null => false, :default => ""
      t.string :practice_phone, :null => false, :default => ""
      t.integer :user_id
      t.timestamps
    end
  end
end
