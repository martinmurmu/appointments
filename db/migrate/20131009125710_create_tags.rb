class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tags, :null => false, :default => ""
      t.integer :consumer_id, :null => false
      t.integer :manager_id, :null => false
      t.timestamps
    end
  end
end
