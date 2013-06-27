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
