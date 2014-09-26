class RemoveDetailsFromManagers < ActiveRecord::Migration
  def up
    remove_column :managers, :practice_name
    remove_column :managers, :practice_phone
    remove_column :managers, :practice_address
  end
end
