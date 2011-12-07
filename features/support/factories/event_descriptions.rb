require 'factory_girl'

Factory.define(:event_description, :class => EventDescription) do |f|
  f.sequence(:name) {|n| "#{n} Ausstellung von DDR Spielzeug-Fotografien" }
  f.description "Onkel Philipp's ..."
  f.association(:location, :factory => :event_location)
end
