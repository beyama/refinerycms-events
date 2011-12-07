class EventDescription < ActiveRecord::Base
  belongs_to :location, :class_name => 'EventLocation', :dependent => :destroy
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  has_and_belongs_to_many :categories, :class_name => 'EventCategory', :join_table => 'event_categories_event_descriptions'
  
  has_many :events, :class_name => 'Event', :foreign_key => :description_id, :autosave => true, :dependent => :destroy 
  
  validates :name, :presence => true

  accepts_nested_attributes_for :location, :reject_if => :all_blank
  accepts_nested_attributes_for :events, :allow_destroy => true
  
  before_validation do |desc|    
    desc.events.each do |event|
      event.location ||= desc.location
    end
  end
  
  before_save do |desc|
    desc.events.each do |event|
      event.created_by = desc.created_by if event.new_record?
      event.updated_by = desc.updated_by if event.changed?
    end
  end
end
