class EventLocation < ActiveRecord::Base
  geocoded_by :full_address, :latitude => :lat, :longitude => :lng
  
  before_save :geocode_address
  
  validates :venue, :presence => true
  
  def geocode?
    lat.present? && lng.present?
  end
  
  def zip_and_city
    zip.present? && city.present? ? "#{zip} #{city}" : (zip.blank? ? city : zip)
  end
  
  protected
  def full_address
    [address, city, zip, state].reject(&:blank?).join(', ')
  end
  
  def geocode_address
    return if address.blank? || (persisted? && !address_changed?)
    fetch_coordinates
  end
  
end