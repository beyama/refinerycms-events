require 'ri_cal'

class Event < ActiveRecord::Base

  belongs_to :location, :class_name => 'EventLocation'
  belongs_to :description, :class_name => 'EventDescription', :counter_cache => true
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  accepts_nested_attributes_for :location, :allow_destroy => true
  
  validates :location, :start_at, :end_at, :presence => true
  
  validate do |event|
    errors.add(:base, I18n.t('.start_at_cant_be_after_end_at')) if event.start_at && event.end_at && event.start_at > event.end_at
  end
  
  scope :start_at, lambda {|date| 
    date = Date.parse(date) if date.is_a?(String)
    where("start_at >= ?", date)
  }
  
  scope :end_at, lambda {|date| 
    date = Date.parse(date) if date.is_a?(String)
    where("end_at < ?", date + 1.day)
  }
  
  scope :search, lambda {|q|
    query = "event_descriptions.name like :q OR event_descriptions.summary like :q OR event_descriptions.description like :q"
    includes(:description).where(query, :q => "%#{q}%")
  }
  
  class << self
    
    def search_location(attr, value)
      includes(:location).where("event_locations.#{attr} like :value", :value => value)
    end
    
    def unexpired
      self.start_at(Time.now)
    end
    
  end
  
  [:venue, :country, :state, :city, :zip].each do |attr|
    scope attr, lambda {|q| search_location(attr, q) }
  end
  
  scope :address, lambda {|q| search_location(:address, "%#{q}%") }

  class << self
    def to_ics(collection, cal=RiCal.Calendar, url=nil)
      collection.each {|ev| ev.to_ics(cal, url) }
      cal
    end
  end

  def title
    self.description.name
  end
  
  def to_param
    @param = nil if self.description.name_changed?
    @param ||= Babosa::Identifier.new("#{super} #{self.description.name}").normalize.to_s
  end
  
  def to_ics(cal=RiCal.Calendar, url=nil)
    event = RiCal::Component::Event.new
    event.dtstart = self.start_at
    event.dtend   = self.end_at
    
    event.summary     = self.description.name
    event.description = self.description.summary
    
    loc = self.location
    event.location = [loc.venue, loc.address, loc.zip_and_city, loc.country, loc.state].reject(&:blank?).join(', ')
    
    event.url = url.call(self) if url
    
    cal.add_subcomponent(event)
    
    cal
  end
  
end
