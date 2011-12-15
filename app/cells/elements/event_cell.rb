module Elements
  class EventCell < Cell::Base

    def display(options)
      @element = options[:element]
      @description = @element.event

      return "" unless @description

      @events = @description.events.unexpired.includes(:location).order('start_at ASC')

      @events = @events.limit(@element.limit) if @element.limit.present?
      @events = @events.all

      return "" if @events.empty?

      render
    end

  end
end
