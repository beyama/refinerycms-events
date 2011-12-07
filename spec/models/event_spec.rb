require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe Event do
  let(:event) { Factory.create(:event) }

  describe "validations" do

    it "should be valid by factory" do
      event.should be_valid
    end

    it "requires start_at" do
      event.start_at = nil
      event.should_not be_valid
    end

    it "requires end_at" do
      event.end_at = nil
      event.should_not be_valid
    end

    it "requires location" do
      event.location = nil
      event.should_not be_valid
    end

    it "requires start_at before end_at" do
      event.end_at = event.start_at - 1.minute
      event.should_not be_valid
    end
    
  end

  describe "location association" do

    it "have a location attribute" do
      event.should respond_to(:location)
    end

    it "have a location association" do
      association = Event.reflect_on_association(:location)
      association.should be_belongs_to
      association.class_name.should == 'EventLocation'
    end

    it "destroys associated locations" do
      location = event.location
      event.destroy
      EventLocation.find_by_id(location.id).should be_nil
    end

    it "destroys only orphaned locations" do
      location = event.location
      event.description.location = location
      event.save
      event.destroy

      EventLocation.find_by_id(location.id).should_not be_nil
    end

  end

  describe "description association" do

    it "have a description attribute" do
      event.should respond_to(:description)
    end

    it "have a description association" do
      association = Event.reflect_on_association(:description)
      association.should be_belongs_to
      association.class_name.should == 'EventDescription'
    end

  end

  describe "user associations" do

    it "have a created_by attribute" do
      event.should respond_to(:created_by)
    end

    it "have a updated_by attribute" do
      event.should respond_to(:updated_by)
    end

    it "have a created_by association" do
      association = Event.reflect_on_association(:created_by)
      association.should be_belongs_to
      association.class_name.should == 'User'
    end

    it "have a updated_by association" do
      association = Event.reflect_on_association(:updated_by)
      association.should be_belongs_to
      association.class_name.should == 'User'
    end

  end

  describe "start_at and end_at scope" do

    before do
      @now = Date.parse('1-1-2011').to_time
      @event_1 = Factory.create(:event, :start_at => @now, :end_at => @now + 4.hours)
      @event_2 = Factory.create(:event, :start_at => @now + 5.hours, :end_at => @now + 8.hours)
    end

    it "returns all events starting now" do
      Event.start_at(@now).should == [@event_1, @event_2]
    end

    it "returns all events starting in 5 hours" do
      Event.start_at(@now + 5.hours).should == [@event_2]
    end

    it "returns all events ends in 4 hours" do
      Event.end_at(@now + 4.hours ).should == [@event_1]
    end

    it "returns all events ends in 8 hours" do
      Event.end_at(@now + 8.hours ).should == [@event_1, @event_2]
    end

    it "returns all events ending today" do
      Event.end_at(@now.to_date).should == [@event_1, @event_2]
    end

  end

  describe "unexpired scope" do

    before do
      now = Time.now
      @event_1 = Factory.create(:event, :start_at => now - 1.day, :end_at => now + 3.days)
      @event_2 = Factory.create(:event, :start_at => now - 3.days, :end_at => now - 1.days)
    end

    it "returns only unexpired events" do
      Event.unexpired.should == [@event_1]
    end

  end

  describe "categoriy scope" do
    let(:description) { event.description }
    let(:category) { Factory.create(:event_category) }

    before do
      description.categories << category
      description.save
    end

    it "returns events by category" do
      Event.category('foo').should be_empty
      Event.category(category.name).should == [event]
    end

  end

  describe "search in location attributes" do
    let(:location) { event.location }
    
    [:venue, :country, :city, :zip].each do |attr|
      describe "##{attr}" do
        it "returns all events with matching #{attr}" do
          Event.send(attr, 'foo').should be_empty
          Event.send(attr, location[attr]).should == [event]
        end
      end
    end

    describe "#address" do
      it "returns all events with matching address" do
        Event.address('foo').should be_empty
        Event.address(location.address).should == [event]
        Event.address(location.address[2..-4]).should == [event]
      end
    end

  end

  describe "#search" do
    let(:description) { event.description }

    it "returns all events with matching description" do
      Event.search('XXXXX').should be_empty
      Event.search(description.name[0..6]).should == [event]
      Event.search(description.description[0..10]).should be_empty == [event]
    end
  end

end
