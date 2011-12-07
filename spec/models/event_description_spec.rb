require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe EventDescription do
  let(:description) { Factory.create(:event_description) }

  describe "validations" do

    it "should be valid by factory" do
      description.should be_valid
    end

    it "requires name" do
      description.name = nil
      description.should_not be_valid
    end

  end

  describe "location association" do

    it "have a location attribute" do
      description.should respond_to(:location)
    end

    it "have a location association" do
      association = EventDescription.reflect_on_association(:location)
      association.should be_belongs_to
      association.class_name.should == 'EventLocation'
    end

    it "destroys associated locations" do
      location = description.location
      description.destroy
      EventLocation.find_by_id(location.id).should be_nil
    end

  end

  describe "user associations" do

    it "have a created_by attribute" do
      description.should respond_to(:created_by)
    end

    it "have a updated_by attribute" do
      description.should respond_to(:updated_by)
    end

    it "have a created_by association" do
      association = EventDescription.reflect_on_association(:created_by)
      association.should be_belongs_to
      association.class_name.should == 'User'
    end

    it "have a updated_by association" do
      association = EventDescription.reflect_on_association(:updated_by)
      association.should be_belongs_to
      association.class_name.should == 'User'
    end

  end

  describe "before_validation" do

    it "should set location to events if event location is nil" do
      event = description.events.build(:start_at => Time.now, :end_at => Time.now + 3.days)
      event.location.should be_nil

      description.valid?
      event.location.should == description.location
    end

  end

  describe "events#unexpired" do

    before do
      now = Time.now
      description.events.build(:start_at => now - 1.day, :end_at => now + 3.days)
      description.events.build(:start_at => now - 3.days, :end_at => now - 1.days)
      description.save
      @event = description.events.first
    end

    it "returns only unexpired events" do
      description.events.unexpired.should == [@event]
    end

  end

end
