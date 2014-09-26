class AddPhoneToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :phone, :string
  end
end
