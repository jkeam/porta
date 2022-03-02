# frozen_string_literal: true

And "there are some application plans defined" do
  steps %(
    And an application plan "Basic" of provider "foo.3scale.localhost"
    And a published application plan "Pro" of provider "foo.3scale.localhost"
    And plan "Basic" has applications
  )
end

When "an admin selects an Application plan as default" do
  select_default_application_plan
end

When "an admin selects a hidden Application plan as default" do
  select_default_application_plan(hidden: true)
end

def select_default_application_plan(hidden: false)
  service = @provider.default_service
  @plan = FactoryBot.create(hidden ? :application_plan : :published_plan, issuer: service)

  visit admin_service_application_plans_path(service)
  steps %(
    And I select "#{@plan.name}" as default plan
    Then I should see "Default plan was updated"
    And plan "#{@plan.name}" should be the default
  )

  assert_equal @plan, service.reload.default_application_plan
end

Then "any new application will use this plan" do
  app = FactoryBot.create(:application, :with_default_plan, service: @provider.default_service)
  assert_equal @plan, app.plan
end

When "an admin is in the Application plans page" do
  visit admin_service_application_plans_path(@provider.default_service)
end

Then "they can add new Application plans" do
  steps %(
    When I follow "Create Application plan"
    And I fill in "Name" with "Basic"
    And I press "Create Application Plan"
    Then I should be at url for the application plans admin page
    And I should see "Created application plan Basic"
  )
end

When "an admin selects the option copy of an Application plan" do
  service = @provider.default_service
  @plan = FactoryBot.create(:application_plan, issuer: service)

  visit admin_service_application_plans_path(service)
  step %(I select option "Copy" from the actions menu for plan "#{@plan.name}")
end

Then "a copy of the plan is added to the list" do
  steps %(
    Then I should see "Plan copied."
    And I should see "#{@plan.name} (copy)"
  )
end

When "an admin clicks on an Application plan" do
  service = @provider.default_service
  @plan = FactoryBot.create(:application_plan, issuer: service, name: "Old name")

  visit admin_service_application_plans_path(service)
  step %(I follow "#{@plan.name}")
end

Then "they can edit its details" do
  old_name = @plan.name
  new_name = 'New name'
  steps %(
    And I fill in "Name" with "#{new_name}"
    And I press "Update Application plan"
    And I should see plan "#{new_name}"
    But I should not see plan "#{old_name}"
  )

  assert_equal current_path, admin_service_application_plans_path(@plan.issuer)
  assert_equal new_name, @plan.reload.name
end

Then "an admin can delete it from the Application plans page" do
  visit admin_service_application_plans_path(@provider.default_service)
  steps %(
    And I select option "Delete" from the actions menu for plan "#{@plan.name}" and I confirm dialog box
    Then I should see "The plan was deleted"
    And I should not see plan "#{@plan.name}"
  )
end

When "an Application plan {is} being used in an(y) application(s)" do |used|
  service = @provider.default_service
  @plan = FactoryBot.create(:application_plan, service: service)
  FactoryBot.create(:cinstance, service: service, plan: @plan) if used

  assert_equal used, @plan.reload.contracts_count.positive?
end

Then "an admin cannot delete it from the Application plans page" do
  visit admin_service_application_plans_path(@provider.default_service)
  step %(I should not see option "Delete" from the actions menu for plan "#{@plan.name}")
end

When "an admin hides a plan from the Application plans page" do
  service = @provider.default_service
  @hidden_plan = FactoryBot.create(:published_plan, issuer: service)
  visit admin_service_application_plans_path(service)
  steps %(
    And I select option "Hide" from the actions menu for plan "#{@hidden_plan.name}"
    Then I should see "Plan #{@hidden_plan.name} was hidden."
    And I should see a hidden plan "#{@hidden_plan.name}"
    And plan "#{@hidden_plan.name}" should be hidden
    And I should not see option "Hide" from the actions menu for plan "#{@hidden_plan.name}"
  )
end

Then "a buyer won't be able to use it for their applications" do
  pending 'TODO'
end

When "an admin publishes a plan from the Application plans page" do
  service = @provider.default_service
  @plan = FactoryBot.create(:application_plan, issuer: service)
  visit admin_service_application_plans_path(service)
  steps %(
    And I select option "Publish" from the actions menu for plan "#{@plan.name}"
    Then I should see "Plan #{@plan.name} was published."
    And I should see a published plan "#{@plan.name}"
    And plan "#{@plan.name}" should be published
    And I should not see option "Publish" from the actions menu for plan "#{@plan.name}"
  )
end

Then "a buyer will be able to use it for their applications" do
  pending 'TODO'
end

When "an admin is looking for an Application plan" do
  steps %(
    Given a published application plan "Plan B" of provider "foo.3scale.localhost"
    And a published application plan "Basic" of provider "foo.3scale.localhost"
    And a published application plan "Plan C" of provider "foo.3scale.localhost"
    And a buyer "foo" signed up to application plan "Basic"
    And a buyer "bar" signed up to application plan "Plan B"
    And I am on the application plans admin page
    Then I should see the following table:
      | Name    | Applications | State     |
      | Basic   | 1            | published |
      | Plan B  | 1            | published |
      | Plan C  | 0            | published |
  )
end

Then "they can filter plans by name" do
  pending "TODO: Use search bar to filter plans"
end

And "they can sort plans by name, no. of apps and state" do
  pending "TODO: Implement sorting"
end
