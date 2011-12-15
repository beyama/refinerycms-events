require 'refinerycms-base'

require 'has_scope'
require 'geocoder'

module Refinery
  module Events

    def self.create_or_update_elements
      ::Elements::ElementBuilder.create_or_update :events do |e|
        e.parent :embedded_element
        e.title 'Events element'
        e.text :title, :maximum => 250, :required => true
        e.text :category, :maximum => 250
        e.integer :limit, :minimum => 0, :maximum => 100
      end  

      ::Elements::ElementBuilder.create_or_update :event do |e|
        e.parent :embedded_element
        e.title 'Event element'
        e.any :event
        e.integer :limit, :minimum => 0, :maximum => 100
      end  
    end

    class Engine < Rails::Engine

      initializer "events element widget", :after => "elements widgets" do
        ::Refinery::Events.create_or_update_elements unless Rails.env.test?
        ::Elements::Widget.register 'EventsView', ['Events']
        ::Elements::Widget.register 'EventView', ['Event']
      end

      initializer "events cell view paths", :after => "apotomo.setup_view_paths" do
        Cell::Base.append_view_path root.join('app/cells')
      end
      
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "events"
          plugin.activity = { :class => Event }
        end
        
        Mime::Type.register "text/calendar", :ics unless defined?(Mime::ICS)
      end
    end
  end
end
