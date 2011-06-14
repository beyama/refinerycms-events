require 'spec_helper'

describe Event do

  def reset_event(options = {})
    @valid_attributes = {
      :id => 1
    }

    @event.destroy! if @event
    @event = Event.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_event
  end

  context "validations" do
    
  end

end