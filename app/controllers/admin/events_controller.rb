module Admin
  class EventsController < Admin::BaseController

    before_filter :find_event, :only => [:edit, :update, :destroy]

    def index
      @events = EventDescription.includes(:events).order('events.start_at DESC')
      @events = @events.where("name like ?", "%#{params[:search]}%") if params[:search].present?
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
      save
    end
    
    def update
      @event.attributes = params[:event]
      @event.updated_by = current_user
      save
    end
    
    def categories
      if request.get?
        @categories = EventCategory.order('name ASC').all
      else
        @categories = EventCategory.where('name in (?)', params[:categories])
        params[:categories].each do |name|
          category = @categories.find{|c| c.name == name }
          EventCategory.create :name => name unless category
        end
        redirect_to admin_events_url, :notice => t('admin.events.categories.categories_saved')
      end
    end

    protected
    def find_event
      @event = EventDescription.find(params[:id])
    end
    
    def save
      if params[:categories].present?
        @event.categories = EventCategory.find(params[:categories])
      end
      
      if @event.save
        (request.xhr? ? flash.now : flash).notice = t('refinery.crudify.updated', :what => "'#{@event.name}'")
        request.xhr? ? render(:partial => "/shared/message") : redirect_to(admin_events_path)
      else
        if request.xhr?
          render :partial => "/shared/admin/error_messages",
                   :locals => {
                     :object => @event,
                     :include_object_name => true
                   }
        else
          render :action => (@event.persisted? ? :edit : :new)
        end
      end
    end

  end
end
