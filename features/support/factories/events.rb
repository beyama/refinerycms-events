require 'factory_girl'

Factory.define(:event, :class => Event) do |f|
  f.start_at Time.now
  f.end_at Time.now + 2.hours
  f.association :description, :factory => :event_description
  f.association :location, :factory => :event_location
end
