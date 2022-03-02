# TODO !!!

@javascript
Feature: Service plans index page

  In order to manage Service plans from the index page, I want to perform the following
  actions: create, copy, edit, delete, publish and hide. Moreover, I want to sort the table
  by name, no. of apps and state.

  Background:
    Given a provider is logged in

  Scenario: Set a default Service plan
    When an admin selects an Service plan as default
    Then any new application will use this plan

  Scenario: Hidden plans can be default
    When an admin selects a hidden Service plan as default
    Then any new application will use this plan

  Scenario: Create an Service plan
    When an admin is in the Service plans page
    Then they can add new Service plans

  Scenario: Copy an Service plan
    When an admin selects the option copy of an Service plan
    Then a copy of the plan is added to the list

  Scenario: Edit an Service plan
    When an admin clicks on an Service plan
    Then they can edit its details

  Scenario: Delete an Service plan
    When an Service plan is not being used in any applications
    Then an admin can delete it from the Service plans page

  Scenario: Delete an Service plan is not allowed if subscribed to any application
    When an Service plan is being used in an application
    Then an admin cannot delete it from the Service plans page

  Scenario: Hide an Service plan
    When an admin hides a plan from the Service plans page
    Then a buyer won't be able to use it for their applications

  Scenario: Publish an Service plan
    When an admin publishes a plan from the Service plans page
    Then a buyer will be able to use it for their applications

  Scenario: Filtering and sorting Service plans
    When an admin is looking for an Service plan
    Then they can filter plans by name
    And they can sort plans by name, no. of apps and state
