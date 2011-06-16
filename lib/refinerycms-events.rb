require 'refinerycms-base'

require 'has_scope'
require 'geokit-rails3'

module Refinery
  module Events
    
    class << self
      def categories
        RefinerySetting.find_or_set(:event_categories, [])
      end
        
      def categories=(ary)
        RefinerySetting.set(:event_categories, ary)
      end
        
    end
    
    class Engine < Rails::Engine
      
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "events"
          plugin.activity = {
            :class => Event}
        end
        
        Mime::Type.register "text/calendar", :ics
      end
    end
  end
end
