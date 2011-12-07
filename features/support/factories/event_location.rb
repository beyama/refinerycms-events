require 'factory_girl'

Factory.define(:event_location, :class => EventLocation) do |f|
  f.venue "Onkel Philipp's Spielzeugwerkstatt"
  f.address "Choriner Str. 35"
  f.city "Berlin"
  f.zip "10435"
  f.country "Deutschland"
end
