require 'spec_helper'
Dir[File.expand_path('../../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe Elements::EventsCell do

  def events_element(attrs={})
    attrs[:title] ||= 'Test events'
    @element = Elements::Types::Events.create!(attrs)
  end

  def render_events(element=events_element)
    @events = render_cell('elements/events', :display, :element => element)
  end

  before(:all) do
    EventCategory.destroy_all
    EventDescription.destroy_all

    3.times do
      category = Factory.create :event_category

      3.times do
        event = Factory.create :event
        event.description.categories << category
        event.description.save
      end
    end
  end

  before(:each) do
    ::Elements::ElementBuilder.create :embedded_element
    ::Refinery::Events.create_or_update_elements
    ::Elements::Types.reload!
  end

  it "should render title" do
    render_events.should have_selector('h2', :content => @element.title)
  end

  it "should render all events" do
    render_events.should have_selector('ul li.event', :count => Event.count)
  end

  it "should only render 3 events if element limit property is 3" do
    element = events_element(:limit => 3)
    render_events(element).should have_selector('ul li.event', :count => 3)
  end

  it "should filter by category" do
    element = events_element(:category => EventCategory.first.name)
    render_events(element).should have_selector('ul li.event', :count => 3)
  end

end if defined? Elements && defined? RSpec::Cells
