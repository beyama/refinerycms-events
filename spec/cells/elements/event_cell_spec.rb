require 'spec_helper'
Dir[File.expand_path('../../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe Elements::EventCell do

  def event_element(attrs={})
    attrs[:event] ||= begin
                        description = Factory.create :event_description
                        6.times do
                          Factory.create :event, :description => description
                        end
                        description
                      end
    @element = Elements::Types::Event.create!(attrs)
  end

  def render_event(element=event_element)
    @event = render_cell('elements/event', :display, :element => element)
  end

  before(:each) do
    ::Elements::ElementBuilder.create :embedded_element
    ::Refinery::Events.create_or_update_elements
    ::Elements::Types.reload!
  end

  describe "#display" do

    it "should render nothing if event is nil" do
      element = event_element
      element.event = nil
      element.save
      render_event(element).should have_no_selector('div.element')
    end

    it "should render nothing if events are empty" do
      element = event_element
      element.event.events(true).clear
      render_event(element).should have_no_selector('div.element')
    end

    it "should render headline" do
      render_event.should have_selector('h2', :content => @element.event.name)
    end

    it "should render all events" do
      render_event.should have_selector('ul li.event', :count => @element.event.events.count)
    end

    it "should only render unexpired events" do
      element = event_element
      events = element.event.events(true)
      events.first.update_attributes(:start_at => Time.now - 1.day, :end_at => Time.now - 23.hours)
      render_event(element).should have_selector('ul li.event', :count => element.event.events.count - 1)
    end

    it "should only render 3 events if element limit property is 3" do
      element = event_element(:limit => 3)
      render_event(element).should have_selector('ul li.event', :count => 3)
    end

  end

end if defined? Elements && defined? RSpec::Cells

