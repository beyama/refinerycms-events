module Admin
  class EventsController < Admin::BaseController

    before_filter :find_event, :only => [:edit, :update, :destroy]

    def index
      @events = EventDescription.includes(:events).order('events.start_at DESC')
      @events = @events.where("name like ?", "%#{params[:search]}%") if params[:search].present?
      @events = @events.paginate(:page => params[:page], :per_page => 20)
      render :partial => 'events' if request.xhr?
    end

    def dialog
      @events = EventDescription
      @events = EventDescription.where("name like ?", "%#{params[:search]}%") if params[:search].present?
      @events = @events.paginate(:page => params[:page], :per_page => 8)

      @callback = params[:callback]
      @selected = params[:selected].present? ? params[:selected].to_i : nil

      if request.xhr?
        render :partial => 'dialog_events'
      else
        render :layout => 'admin_dialog'
      end
    end if defined?(Elements)

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

    def destroy
      title = @event.name
      if @event.destroy
        flash.notice = t('destroyed', :scope => 'refinery.crudify', :what => "'#{title}'")
      end

      redirect_to admin_events_url
    end    

    def categories
      if request.get?
        @categories = EventCategory.order('name ASC').all
      else
        @categories = EventCategory.all

        names = []
        params[:categories].select {|attrs| attrs.has_key?(:id) }.each do |attrs|
          id = attrs[:id]
          category = @categories.find{|c| c.id.to_s == id }
          if category
            name = attrs[:name]
            if attrs[:_destroy] == 'true' || name.blank? || names.include?(name)
              category.destroy
            else
              if category.name != name
                category.name = name
                category.save
              end
              names << name
            end
          end
        end

        params[:categories].reject {|attrs| attrs.has_key?(:id) }.each do |attrs|
          name = attrs[:name]
          EventCategory.create :name => name unless name.blank? || names.include?(name)
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
      
      message = @event.new_record? ? 'refinery.crudify.created' : 'refinery.crudify.updated'
      
      if @event.save
        (request.xhr? ? flash.now : flash).notice = t(message, :what => "'#{@event.name}'")
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

    protected

    def restrict_controller
      super unless action_name == 'dialog'
    end

    def store_current_location!
      super unless action_name == 'dialog'
    end 

  end
end
