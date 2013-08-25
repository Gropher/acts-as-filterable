module ActsAsFilterable
  module Filterable
    def acts_as_filterable options
      class_attribute :filter_attributes
      class_attribute :filter_variables

      self.filter_attributes = (options[:only] || self.new.attributes.keys.map(&:to_sym) - options[:except].to_a.map(&:to_sym)).map(&:to_sym)
      self.filter_variables = (options[:variables] || []).map(&:to_sym)

      class_eval do
        scope :filter, ->(filter, variables={}) do
          query = process_filter_query filter.query.with_indifferent_access, variables
          ransack(query).result
        end
      protected
        def self.process_filter_query query, variables
          if query[:g]
            process_advanced_query query, variables
          else
            process_simple_query query, variables
          end
        end

        def self.process_simple_query query, variables
          Hash[query.map {|k,v| filter_attributes.include?(k.to_s.gsub(/(_not)?(_[a-z]+)$/, '').to_sym) ? [k, substitute_filter_variable(v, variables)] : nil }.compact]
        end

        def self.process_advanced_query query, variables
          query = query.dup
          query[:g].keep_if do |index, condition_group| 
            attributes = condition_group[:c].values.flatten.map {|v| v[:a].values }.flatten.map {|v| v[:name].to_sym }
            (attributes - filter_attributes).empty? 
          end
          query[:g].each do |condition_group_key, condition_group| 
            condition_group[:c].each do |condition_key, condition| 
              condition[:v].each do |value_key, value| 
                value[:value] = substitute_filter_variable(value[:value], variables)
              end
            end
          end
          query
        end

        def self.substitute_filter_variable value, variables
          if value =~ /%%[a-z_]+%%/ && filter_variables.include?(value[2..-3].to_sym)
            variables[value[2..-3].to_sym]
          else
            value
          end
        end
      end
    end
  end
end
