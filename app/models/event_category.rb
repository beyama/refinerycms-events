class EventCategory < ActiveRecord::Base
  has_and_belongs_to_many :descriptions, :class_name => 'EventDescription', :join_table => 'event_categories_event_descriptions'
  
  validates :name, :presence => true, :uniqueness => true
end