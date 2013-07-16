class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.column :id, :integer
      t.column :name, :string
      t.column :query, :text
      
      t.timestamps
    end
    
    add_index :filters, :name
  end
  
  def self.down
    drop_table :filters
  end
end
