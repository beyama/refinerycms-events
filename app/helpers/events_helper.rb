module EventsHelper
  
  def map_link(text, location)
    "<a target='_blank' href='http://maps.google.com/maps?hl=de&ie=UTF8&ll=#{location.lat},#{location.lng}' class='map'>#{text}</a>".html_safe
  end
  
  def options_for_event_category_select
    options_for_select(EventCategory.order('name ASC').all.map{|c| [c.name, c.name.downcase]}, params[:category])
  end
  
end