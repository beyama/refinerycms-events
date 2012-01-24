@events @dialog @elements
Feature: Events
  In order to select an event from an element
  As an administrator
  I want to select events from a dialog

  Background:
    Given I am a logged in refinery user
    And I have no events

  @events-list @list
  Scenario: Events list
    When I go to the events dialog
    Then I should see "There are no Events yet."

  @events-list @list
  Scenario: Events list
    Given I have events with the following attributes:
      | name      | venue     | start         | end            |
      | Hamlet    | Old opera | 2011-6-5 8:10 | 2011-6-5 10:00 |
      | Cymbeline | New opera | 2011-6-6 9:30 | 2011-6-6 11:40 |
    When I go to the events dialog
    Then I should see "Hamlet"
    And I should see "Cymbeline"

  @events-list @list @search
  Scenario: Events list
    Given I have events with the following attributes:
      | name      | venue     | start         | end            |
      | Hamlet    | Old opera | 2011-6-5 8:10 | 2011-6-5 10:00 |
      | Cymbeline | New opera | 2011-6-6 9:30 | 2011-6-6 11:40 |
    When I go to the events dialog
    Then I fill in "search" with "Ham"
    And I press "Search"
    And I should see "Hamlet"
    And I should not see "Cymbeline"
