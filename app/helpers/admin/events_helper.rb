module Admin
  module EventsHelper
    
    def link_to_remove_event(f)
      f.hidden_field(:_destroy) + link_to_function(t('.remove_event'), "remove_event(this)")
    end
    
    def link_to_add_event(f)
      event = Event.new(:location => EventLocation.new)
      fields = f.fields_for(:events, event, :child_index => "new_event") do |builder|
        render("event_fields", :f => builder, :event => event)
      end
      link_to_function(t('.add_event'), "add_event(this, '#{escape_javascript(fields)}')", :class => 'add')
    end
    
  end
end