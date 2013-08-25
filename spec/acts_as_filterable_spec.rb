require 'spec_helper'

class MyModel < ActiveRecord::Base
  acts_as_filterable :only => [:name, :description, :counter, :user_id], :variables => [:current_user_id]
end

class MyOtherModel < ActiveRecord::Base
  acts_as_filterable :except => [:private_field], :variables => [:current_user_id]
end

describe ActsAsFilterable do
  it 'create filter by name' do
    Filter.create! name: 'test1', query: { name_cont: 'test1' } 
    Filter.count.should == 1
  end

  it 'apply filter correctly with :only definition' do
    results = MyModel.filter Filter.find_by_name('test1')
    results.count.should == 0
    MyModel.create! :name => 'test1'
    MyModel.create! :name => 'test2'
    results = MyModel.filter Filter.find_by_name('test1')
    results.count.should == 1
  end

  it 'apply filter correctly with :except definition' do
    results = MyOtherModel.filter Filter.find_by_name('test1')
    results.count.should == 0
    MyOtherModel.create! :name => 'test1'
    MyOtherModel.create! :name => 'test2'
    results = MyOtherModel.filter Filter.find_by_name('test1')
    results.count.should == 1
  end

  it 'search only by allowed fields with :only definition' do
    MyModel.create! :name => 'test2', :private_field => 'something'
    f = Filter.create! name: 'test_private', query: { private_field_cont: 'something' }
    MyModel.filter(f).count.should > 1
  end

  it 'search only by allowed fields with :except definition' do
    MyOtherModel.create! :name => 'test2', :private_field => 'something'
    f = Filter.create! name: 'test_private', query: { private_field_cont: 'something' }
    MyOtherModel.filter(f).count.should > 1
  end

  it 'uses variables correctly with :only definition' do
    MyModel.create! :name => 'test3', :user_id => 123
    f = Filter.create! name: 'test_variable', query: { user_id_eq: '%%current_user_id%%' }
    MyModel.filter(f, current_user_id: 123).count.should == 1
    MyModel.filter(f, current_user_id: 321).count.should == 0
  end

  it 'uses variables correctly with :except definition' do
    MyOtherModel.create! :name => 'test3', :user_id => 123
    f = Filter.create! name: 'test_variable', query: { user_id_eq: '%%current_user_id%%' }
    MyOtherModel.filter(f, current_user_id: 123).count.should == 1
    MyOtherModel.filter(f, current_user_id: 321).count.should == 0
  end

  it 'don\'t substitude unlisted variables with :only definition' do
    MyModel.create! :name => 'test3', :user_id => 123
    f = Filter.create! name: 'test_variable', query: { user_id_eq: '%%some_other_variable%%' }
    MyModel.filter(f, current_user_id: 123).count.should == 0
    MyModel.filter(f, current_user_id: 321).count.should == 0
  end

  it 'don\'t substitude unlisted variables with :except definition' do
    MyOtherModel.create! :name => 'test3', :user_id => 123
    f = Filter.create! name: 'test_variable', query: { user_id_eq: '%%some_other_variable%%' }
    MyOtherModel.filter(f, current_user_id: 123).count.should == 0
    MyOtherModel.filter(f, current_user_id: 321).count.should == 0
  end

  ############################################# Advanced Queries ####################################################
  it 'create and apply filter with advanced query' do
    filter = Filter.create! name: 'adv_test1', query: ADVANCED_QUERY
    
    MyModel.create! :name => 'adv_test1', :user_id => 999
    MyModel.create! :name => 'adv_test2', :user_id => 999
    MyModel.create! :name => 'adv_test3', :user_id => 666
    MyModel.filter(filter, current_user_id: 999).count.should == 2
  end
end
