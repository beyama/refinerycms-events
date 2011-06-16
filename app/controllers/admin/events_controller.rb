module Admin
  class EventsController < Admin::BaseController

    before_filter :find_event, :only => [:edit, :update, :destroy]

    def index
      @events = EventDescription.includes(:events).order('events.start_at ASC')
      @events = @events.paginate(:page => params[:page], :per_page => 20)
      render :partial => 'events' if request.xhr?
    end

    def new
      @event = EventDescription.new
      @event.events.build
      @event.location = EventLocation.new
    end

    def create
      @event = EventDescription.new(params[:event])
      @event.created_by = current_user
      @event.updated_by = current_user
      
      if @event.save
        redirect_to admin_events_path, :notice => t('refinery.crudify.created', :what => "'#{@event.name}'")
      else
        render :action => :new
      end
    end
    
    def update
      @event.attributes = params[:event]
      @event.updated_by = current_user
      
      if @event.save
        redirect_to admin_events_path, :notice => t('refinery.crudify.updated', :what => "'#{@event.name}'")
      else
        render :action => :edit
      end
    end
    
    def categories
      if request.get?
        @categories = Refinery::Events.categories
      else
        Refinery::Events.categories = params[:categories] ? 
          params[:categories].map(&:strip).reject(&:blank?).uniq.sort{|a,b| a.downcase <=> b.downcase } : []
        redirect_to admin_events_url, :notice => t('admin.events.categories.categories_saved')
      end
    end

    protected
    def find_event
      @event = EventDescription.find(params[:id])
    end

  end
end
