class AddTokenToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :token, :string
  end
end
