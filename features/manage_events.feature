@events
Feature: Events
  In order to have events on my website
  As an administrator
  I want to manage events

  Background:
    Given I am a logged in refinery user
    And I have no events

  @events-list @list
  Scenario: Events list
    Given I have events with the following attributes:
      | name      | venue     | start         | end            |
      | Hamlet    | Old opera | 2011-6-5 8:10 | 2011-6-5 10:00 |
      | Cymbeline | New opera | 2011-6-6 9:30 | 2011-6-6 11:40 |
    When I go to the list of events
    Then I should see "Hamlet"
    And I should see "Cymbeline"

  @events-valid @valid
  Scenario: Create valid event
    When I go to the list of events
    And I follow "Add new event"
    And I fill in "Name" with "Hamlet"
    And I fill in "Venue" with "New opera"
    And I press "Save"
    Then I should see "'Hamlet' was successfully added."
    And I should have 1 event

  @events-invalid @invalid
  Scenario: Create invalid event
    When I go to the list of events
    And I follow "Add new event"
    And I press "Save"
    Then I should see "Name can't be blank"
    And I should have 0 events

  @events-edit @edit
  Scenario: Edit existing event
    Given I only have events titled Hamlet
    When I go to the list of events
    And I follow "Edit this event" within ".actions"
    Then I fill in "Name" with "A different name"
    And I press "Save"
    Then I should see "'A different name' was successfully updated."
    And I should be on the list of events
    And I should not see "A differnet name"

  @events-delete @delete
  Scenario: Delete event
    Given I only have events titled Hamlet
    When I go to the list of events
    And I follow "Remove this event forever" within ".actions"
    Then I should see "'Hamlet' was successfully removed."
    And I should have 0 events

