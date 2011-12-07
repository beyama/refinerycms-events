require 'factory_girl'

Factory.define(:event_category, :class => EventCategory) do |f|
  f.sequence(:name) {|n| "category #{n}" }
end
