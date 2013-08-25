require 'rubygems'
require 'bundler/setup'

require 'rails/all'
require 'acts_as_filterable'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:database => "#{root}/db/acts_as_filterable.db"
)

RSpec.configure do |config|
  # some (optional) config here
end

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_other_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'filters'")
ActiveRecord::Base.connection.create_table(:my_models) do |t|
  t.integer :id
  t.string :name
  t.text :description
  t.integer :counter
  t.integer :user_id
  t.string :private_field
  t.datetime "created_at"
  t.datetime "updated_at"
end
ActiveRecord::Base.connection.create_table(:my_other_models) do |t|
  t.integer :id
  t.string :name
  t.text :description
  t.integer :counter
  t.integer :user_id
  t.string :private_field
  t.datetime "created_at"
  t.datetime "updated_at"
end
ActiveRecord::Base.connection.create_table(:filters) do |t|
  t.integer :id
  t.string :name
  t.text :query
  t.datetime "created_at"
  t.datetime "updated_at"
end

ADVANCED_QUERY = {
  :s => {
    '0' => {
      :name => 'id',
      :dir => 'desc'
    }
  },
  :g => { 
    '0' => { 
      :m => 'and', 
      :c => { 
        '0' => { 
          :a => { 
            '0' => { name: 'name' }
          }, 
          :p => 'matches', 
          :v => { 
            '0' => { value: 'adv_%' } 
          } 
        } 
      } 
    },
    '1' => { 
      :m => 'and', 
      :c => { 
        '0' => { 
          :a => { 
            '0' => { name: 'user_id' }
          }, 
          :p => 'eq', 
          :v => { 
            '0' => { value: '%%current_user_id%%' } 
          } 
        } 
      } 
    }
  } 
}
