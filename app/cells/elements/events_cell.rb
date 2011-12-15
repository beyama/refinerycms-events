module Elements
  class EventsCell < Cell::Base

    def display(options)
      @element = options[:element]
      @events = Event.order('start_at ASC')

      apply_scopes

      if @element.has_property?(:limit) && @element.limit.present?
        @events = @events.limit(@element.limit)
      end

      @events = @events.all
      render
    end

    protected

    def apply_scopes
      [ :search, :start_at, :end_at, :venue, :address, :city, 
        :country, :state, :zip, :category ].each do |scope|

        if @element.has_property?(scope) && (value = @element.send(scope)).present?
          @events = @events.send(scope, value)
        end
      end

    end

  end
end
