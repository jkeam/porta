# frozen_string_literal: true

And "there are some service plans defined" do
  steps %(
    And an service plan "Basic" of provider "foo.3scale.localhost"
    And a published service plan "Pro" of provider "foo.3scale.localhost"
    And plan "Basic" has applications
  )
end

When "an admin selects an Service pla as default" do
  select_default_application_plan
end

When "an admin selects a hidden Service pla as default" do
  select_default_application_plan(hidden: true)
end

def select_default_application_plan(hidden: false)
  service = @provider.default_service
  @plan = FactoryBot.create(hidden ? :service_plan : :published_plan, issuer: service)

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

When "an admin is in the Service plas page" do
  visit admin_service_application_plans_path(@provider.default_service)
end

Then "they can add new Service plas" do
  steps %(
    When I follow "Create Service pla"
    And I fill in "Name" with "Basic"
    And I press "Create Application Plan"
    Then I should be at url for the service plans admin page
    And I should see "Created service plan Basic"
  )
end

When "an admin selects the option copy of an Service pla" do
  service = @provider.default_service
  @plan = FactoryBot.create(:service_plan, issuer: service)

  visit admin_service_application_plans_path(service)
  step %(I select option "Copy" from the actions menu for plan "#{@plan.name}")
end

Then "a copy of the plan is added to the list" do
  steps %(
    Then I should see "Plan copied."
    And I should see "#{@plan.name} (copy)"
  )
end

When "an admin clicks on an Service pla" do
  service = @provider.default_service
  @plan = FactoryBot.create(:service_plan, issuer: service, name: "Old name")

  visit admin_service_application_plans_path(service)
  step %(I follow "#{@plan.name}")
end

Then "they can edit its details" do
  old_name = @plan.name
  new_name = 'New name'
  steps %(
    And I fill in "Name" with "#{new_name}"
    And I press "Update Service pla"
    And I should see plan "#{new_name}"
    But I should not see plan "#{old_name}"
  )

  assert_equal current_path, admin_service_application_plans_path(@plan.issuer)
  assert_equal new_name, @plan.reload.name
end

Then "an admin can delete it from the Service plas page" do
  visit admin_service_application_plans_path(@provider.default_service)
  steps %(
    And I select option "Delete" from the actions menu for plan "#{@plan.name}" and I confirm dialog box
    Then I should see "The plan was deleted"
    And I should not see plan "#{@plan.name}"
  )
end

When "an Service pla {is} being used in an(y) application(s)" do |used|
  service = @provider.default_service
  @plan = FactoryBot.create(:service_plan, service: service)
  FactoryBot.create(:cinstance, service: service, plan: @plan) if used

  assert_equal used, @plan.reload.contracts_count.positive?
end

Then "an admin cannot delete it from the Service plas page" do
  visit admin_service_application_plans_path(@provider.default_service)
  step %(I should not see option "Delete" from the actions menu for plan "#{@plan.name}")
end

When "an admin hides a plan from the Service plas page" do
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

When "an admin publishes a plan from the Service plas page" do
  service = @provider.default_service
  @plan = FactoryBot.create(:service_plan, issuer: service)
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

When "an admin is looking for an Service pla" do
  steps %(
    Given a published service plan "Plan B" of provider "foo.3scale.localhost"
    And a published service plan "Basic" of provider "foo.3scale.localhost"
    And a published service plan "Plan C" of provider "foo.3scale.localhost"
    And a buyer "foo" signed up to service plan "Basic"
    And a buyer "bar" signed up to service plan "Plan B"
    And I am on the service plans admin page
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
