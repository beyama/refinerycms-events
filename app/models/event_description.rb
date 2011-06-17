class EventDescription < ActiveRecord::Base
  
  if defined? ActsAsTaggableOn
    acts_as_taggable_on :categories
  else
    def self.taggable?
      false
    end
  end
  
  belongs_to :location, :class_name => 'EventLocation'
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  has_many :events, :class_name => 'Event', :foreign_key => :description_id, :autosave => true do
    
    def unexpired
      self.start_at(Time.now)
    end

  end
  
  accepts_nested_attributes_for :location, :reject_if => :all_blank
  accepts_nested_attributes_for :events, :allow_destroy => true
  
  before_validation do |desc|
    if self.class.taggable?
      categories = Refinery::Events.categories
      self.category_list = self.category_list.select{|category| categories.include?(category)}
    end
    
    desc.events.each do |event|
      event.location ||= desc.location
      event.category_list = desc.category_list if self.class.taggable?
    end
  end
  
  before_save do |desc|
    desc.events.each do |event|
      event.created_by = desc.created_by if event.new_record?
      event.updated_by = desc.updated_by if event.changed?
    end
  end
  
  after_save do |desc|
    if self.class.taggable? 
      desc.events.each do |event|
        if event.category_list != desc.category_list
          event.category_list = desc.category_list
          event.save
        end
      end
    end
  end
  
end