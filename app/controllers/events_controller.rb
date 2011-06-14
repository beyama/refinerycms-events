class EventsController < ApplicationController
  respond_to :html, :ics

  has_scope :search
  has_scope :start_at
  has_scope :end_at
  has_scope :venue
  has_scope :address
  has_scope :city
  has_scope :country
  has_scope :state
  has_scope :zip

  def index
    find_all_events
    
    respond_with do |format|
      format.html do
        find_page
        present(@page)
      end
      format.ics  { render :text => Event.to_ics(@events, RiCal.Calendar, method(:event_url)) }
    end
  end

  def show
    @event = Event.find(params[:id])
    
    respond_with do |format|
      format.html do
        find_page
        @upcoming = Event.unexpired.order("start_at ASC").where("id != ?", @event.id).limit(10)
        @other_dates = @event.description.events.unexpired.where("events.id != ?", @event.id)
        present(@page)
      end
      format.ics  { render :text => @event.to_ics(RiCal.Calendar, method(:event_url)) }
    end
  end

protected

  def find_all_events
    base = params[:start_at].blank? ? Event.unexpired : Event
    @events = apply_scopes(base).order("start_at ASC").all
  end

  def find_page
    @page = Page.where(:link_url => "/events").first
  end

end
