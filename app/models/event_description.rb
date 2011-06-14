class EventDescription < ActiveRecord::Base
  
  belongs_to :location, :class_name => 'EventLocation'
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  has_many :events, :class_name => 'Event', :foreign_key => :description_id do
    
    def unexpired
      self.start_at(Time.now)
    end
    
  end
  
  accepts_nested_attributes_for :location, :reject_if => :all_blank
  accepts_nested_attributes_for :events, :allow_destroy => true
  
  before_validation do |desc|
    desc.events.each {|event| event.location ||= desc.location }
  end
  
end