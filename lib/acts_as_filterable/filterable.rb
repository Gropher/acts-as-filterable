module ActsAsFilterable
  module Filterable
    def acts_as_filterable options
      class_attribute :filter_attributes
      class_attribute :filter_variables

      self.filter_attributes = (options[:only] || self.new.attributes.keys.map(&:to_sym) - options[:except].to_a.map(&:to_sym)).map(&:to_sym)
      self.filter_variables = (options[:variables] || []).map(&:to_sym)

      class_eval do
        scope :filter, ->(filter, variables={}) do
          query = process_filter_query filter.query, variables
          ransack(query).result
        end
      protected
        def self.process_filter_query query, variables
          Hash[query.map {|k,v| filter_attributes.include?(k.to_s.gsub(/(_[a-z]+)$/, '').to_sym) ? [k, substitute_filter_variable(v, variables)] : nil }.compact]
        end
        def self.substitute_filter_variable value, variables
          if value =~ /%[a-z_]+%/ && filter_variables.include?(value[1..-2].to_sym)
            variables[value[1..-2].to_sym]
          else
            value
          end
        end
      end
    end
  end
end
