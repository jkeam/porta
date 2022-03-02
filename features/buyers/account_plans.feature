# TODO !!!

@javascript
Feature: Account plans index page

  In order to manage Account plans from the index page, I want to perform the following
  actions: create, copy, edit, delete, publish and hide. Moreover, I want to sort the table
  by name, no. of apps and state.

  Background:
    Given a provider "foo.3scale.localhost"
    And current domain is the admin domain of provider "foo.3scale.localhost"
    And I am logged in as provider "foo.3scale.localhost"
    And an Account plan "Basic" of provider "foo.3scale.localhost"
    And plan "Basic" has Accounts
    And I go to the Account plans admin page

  Scenario: Create a simple Account plan
    When I follow "Create Account plan"
    And I fill in "Name" with "Basic"
    And I press "Create Account Plan"
    Then I should be at url for the Account plans admin page
    And I should see "Created Account plan Basic"

  Scenario: Copy an Account plan
    When I select option "Copy" from the actions menu for plan "Basic"
    Then I should see "Plan copied."
    And I should see "Basic (copy)"

  Scenario: Edit an Account plan
    Given an Account plan "Pro" of provider "foo.3scale.localhost"
    And I go to the Account plans admin page
    And I follow "Pro"
    And I fill in "Name" with "Enterprise"
    And I press "Update Account plan"
    Then I should be at url for the Account plans admin page
    And I should see plan "Enterprise"
    But I should not see plan "Pro"

  Scenario: Delete an Account plan
    Given an Account plan "Deleteme" of provider "foo.3scale.localhost"
    When I go to the Account plans admin page
    And I select option "Delete" from the actions menu for plan "Deleteme" and I confirm dialog box
    Then I should see "The plan was deleted"
    And I should not see plan "Deleteme"

  Scenario: Delete an Account plan is not allowed if subscribed to any Account
    Then I should not see option "Delete" from the actions menu for plan "Basic"

  Scenario: Hide an Account plan
    Given a published plan "Public Plan" of provider "foo.3scale.localhost"
    When I go to the Account plans admin page
    And I select option "Hide" from the actions menu for plan "Public Plan"
    Then I should see "Plan Public Plan was hidden."
    And I should see a hidden plan "Public Plan"
    And plan "Public Plan" should be hidden
    And I should not see option "Hide" from the actions menu for plan "Public Plan"

  Scenario: Publish an Account plan
    Given a hidden plan "Secret Plan" of provider "foo.3scale.localhost"
    When I go to the Account plans admin page
    And I select option "Publish" from the actions menu for plan "Secret Plan"
    Then I should see "Plan Secret Plan was published."
    And I should see a published plan "Secret Plan"
    And plan "Secret Plan" should be published
    And I should not see option "Publish" from the actions menu for plan "Secret Plan"

  Scenario: Sorting Account plans
    Given a published Account plan "Plan B" of provider "foo.3scale.localhost"
    And a published Account plan "Plan C" of provider "foo.3scale.localhost"
    And a buyer "foo" signed up to Account plan "Basic"
    And a buyer "bar" signed up to Account plan "Plan B"
    And I am on the Account plans admin page
    Then I should see the following table:
      | Name    | Accounts | State     |
      | Basic   | 2            | hidden    |
      | Plan B  | 1            | published |
      | Plan C  | 0            | published |

    # TODO: Column sorting not yet implemented
    # And I press on "Name" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan A  | 2            | hidden    |
    #   | Plan B  | 1            | published |
    #   | Plan C  | 0            | published |

    # And I press on "Name" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan C  | 0            | published |
    #   | Plan B  | 1            | published |
    #   | Plan A  | 2            | hidden    |

    # And I press on "Accounts" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan A  | 2            | hidden    |
    #   | Plan B  | 1            | published |
    #   | Plan C  | 0            | published |

    # And I press on "Accounts" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan C  | 0            | published |
    #   | Plan B  | 1            | published |
    #   | Plan A  | 2            | hidden    |

    # And I press on "State" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan A  | 2            | hidden    |
    #   | Plan C  | 0            | published |
    #   | Plan B  | 1            | published |

    # And I press on "State" within the table header
    # Then I should see following table:
    #   | Name    | Accounts | State     |
    #   | Plan C  | 0            | published |
    #   | Plan B  | 1            | published |
    #   | Plan A  | 2            | hidden    |
