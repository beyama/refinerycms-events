module EventsHelper
  
  def map_link(text, location)
    "<a target='_blank' href='http://maps.google.com/maps?hl=de&ie=UTF8&ll=#{location.lat},#{location.lng}' class='map'>#{text}</a>".html_safe
  end
  
end