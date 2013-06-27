require 'active_record'
require 'ransack'

require 'acts_as_filterable/version'
require 'acts_as_filterable/filterable'
require 'acts_as_filterable/filter'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ActsAsFilterable::Filterable
end

module ActsAsFilterable
end
