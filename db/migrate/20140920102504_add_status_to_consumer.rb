class AddStatusToConsumer < ActiveRecord::Migration
  def change
    add_column :consumers, :status, :string
  end
end
