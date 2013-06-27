# ActsAsFilterable

This gem allows you to save your Ransack search queries to database as filter objects. Also you'll be able to choose models, attributes and variable names you want to use in your queries.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_filterable'

And then execute:

    $ bundle

Or install it manually:

    $ gem install acts_as_filterable

## Usage

Generate migration that creates metadata tables: 

    $ rails g acts_as_filterable:migration

Add acts_as_filterable to your models. Specify filterable columns as `only` or `except` list. Optionally add some allowed variable names:

    class MyModel < ActiveRecord::Base
      acts_as_filterable only: [:name, :description, :counter, :user_id], variables: [:current_user_id] 
    end

or

    class MyOtherModel < ActiveRecord::Base
      acts_as_filterable :except => [:private_field], :variables => [:current_user_id]
    end

Create filters in your database:

    Filter.create! name: 'test1', query: { name_cont: 'test1' } 


Its ready to use:

    MyModel.create! :name => 'test1'
    MyModel.create! :name => 'test2'
    MyModel.filter Filter.find_by_name('test1')

Also you can create parameterized queries:

    MyModel.create! name: 'test3', :user_id => 123
    f = Filter.create! name: 'test_variable', query: { user_id_eq: '%current_user_id%' }
    MyModel.filter f, current_user_id: 123

There are more usage examples in spec directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
