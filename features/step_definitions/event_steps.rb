Given /^I have no events$/ do
  EventDescription.delete_all
end

Given /^A simple events page exists$/ do
  load File.expand_path('../../../db/seeds/events.rb', __FILE__)
end

Then /^I should have ([0-9]+) events?$/ do |count|
  Event.count.should == count.to_i
end

Then /^I have events with the following attributes:$/ do |table|
  table.hashes.each do |attrs|
    start = attrs.has_key?('start') ? DateTime.parse(attrs.delete('start')) : Time.now 
    endt  = attrs.has_key?('end') ? DateTime.parse(attrs.delete('end')) : (start + 2.hours) 
    location = EventLocation.new :venue => attrs.delete('venue')
    ed = EventDescription.new(attrs)
    ed.location = location
    ed.events.build :start_at => start, :end_at => endt
    
    user = User.first
    ed.created_by = user
    ed.updated_by = user

    ed.save!
  end
end

Given /^I (only )?have events titled "?([^\"]*)"?$/ do |only, titles|
  EventDescription.delete_all if only
  titles.split(', ').each do |title|
    ed = EventDescription.new :name => title
    ed.location = EventLocation.new :venue => "New opera"
    ed.events.build :start_at => Time.now, :end_at => (Time.now + 2.hours)
    
    user = User.first
    ed.created_by = user
    ed.updated_by = user

    ed.save!
  end
end


