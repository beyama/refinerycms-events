@events
Feature: Events frontend
  In order to plan my weekend
  As an site visitor
  I want search for events near me

  Background:
    Given I have no events
    And A simple events page exists
    And A Refinery user exists

  @events-list @list
  Scenario: Events frontend list
    Given I have events with the following attributes:
      | name      | venue     | start         | end            |
      | Hamlet    | Old opera | 2011-6-5 8:10 | 2011-6-5 10:00 |
      | Cymbeline | New opera | 2011-6-6 9:30 | 2011-6-6 11:40 |
    When I go to the frontend list of events
    Then I should not see "Hamlet"
    And I should not see "Cymbeline"

    When I fill in "Start" with "2011-6-5"
    And I press "Search"
    Then I should see "Hamlet"
    And I should see "Cymbeline"

    When I fill in "Start" with "2011-6-6"
    And I press "Search"
    Then I should not see "Hamlet"
    And I should see "Cymbeline"
    

  @events-show @show
  Scenario: Events frontend show
    Given I have events with the following attributes:
      | name   | description                    | venue     | start         | end            |
      | Hamlet | The Tragical History of Hamlet | Old opera | 2011-6-5 8:10 | 2011-6-5 10:00 |
    When I go to the frontend list of events
    And I fill in "Start" with "2011-6-5"
    And I press "Search"
    And I follow "Hamlet"
    Then I should see "The Tragical History of Hamlet"
