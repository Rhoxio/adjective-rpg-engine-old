# module Adjective

#   class Inventory

#     attr_reader :initialized_at, :max_size
#     attr_accessor :items, :default_sort

#     def initialize(items = [], opts = {}) 
#       @items = items
#       @initialized_at = Time.now
#       @max_size = opts[:max_size] ||= :unlimited
#       @default_sort_method = opts[:default_sort_method] ||= :created_at
#       validate_inventory_capacity
#       validate_attribute(opts[:default_sort]) if opts[:default_sort]
#     end



#   end
# end
