class EventLocation < ActiveRecord::Base
  
  before_save :geocode_address
  
  def geocode?
    lat.present? && lng.present?
  end
  
  def zip_and_city
    zip.present? && city.present? ? "#{zip} #{city}" : (zip.blank? ? city : zip)
  end
  
  protected
  def geocode_address
    return if address.blank? || (persisted? && !address_changed?)
    
    query = [address, city, zip, state].reject(&:blank?).join(', ')
    geo = Geokit::Geocoders::MultiGeocoder.geocode(query)
    if geo.success
      self.lat = geo.lat
      self.lng = geo.lng
    else
      errors.add(:address, I18n.t('.could_not_geocode_address'))
    end
  end
  
end