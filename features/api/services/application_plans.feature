@javascript
Feature: Application plans index page

  In order to manage Application plans from the index page, I want to perform the following
  actions: create, copy, edit, delete, publish and hide. Moreover, I want to sort the table
  by name, no. of apps and state.

  Background:
    Given a provider is logged in

  Scenario: Set a default Application plan
    When an admin selects an Application plan as default
    Then any new application will use this plan

  Scenario: Hidden plans can be default
    When an admin selects a hidden Application plan as default
    Then any new application will use this plan

  Scenario: Create an Application plan
    When an admin is in the Application plans page
    Then they can add new Application plans

  Scenario: Copy an Application plan
    When an admin selects the option copy of an Application plan
    Then a copy of the plan is added to the list

  Scenario: Edit an Application plan
    When an admin clicks on an Application plan
    Then they can edit its details

  Scenario: Delete an Application plan
    When an Application plan is not being used in any applications
    Then an admin can delete it from the Application plans page

  Scenario: Delete an Application plan is not allowed if subscribed to any application
    When an Application plan is being used in an application
    Then an admin cannot delete it from the Application plans page

  Scenario: Hide an Application plan
    When an admin hides a plan from the Application plans page
    Then a buyer won't be able to use it for their applications

  Scenario: Publish an Application plan
    When an admin publishes a plan from the Application plans page
    Then a buyer will be able to use it for their applications

  Scenario: Filtering and sorting Application plans
    When an admin is looking for an Application plan
    Then they can filter plans by name
    And they can sort plans by name, no. of apps and state
