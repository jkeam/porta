# frozen_string_literal: true

class ApplicationPlanDecorator < PlanBaseDecorator

  def link_to_edit(**options)
    h.link_to(name, h.edit_admin_application_plan_path(self), options)
  end

  def link_to_applications(**options)
    live_applications = cinstances.live
    text = h.pluralize(live_applications.size, 'application')

    if h.can?(:show, Cinstance)
      h.link_to(text, plan_path, options)
    else
      text
    end
  end

  def plan_path
    service = context.fetch(:service) { object.service }
    h.admin_service_applications_path(service, search: { plan_id: id })
  end

  def index_table_data
    {
      id: id,
      name: name,
      editPath: h.edit_polymorphic_path([:admin, object]),
      contracts: contracts_count,
      contractsPath: h.admin_service_applications_path(service, search: { plan_id: id }),
      state: state,
      actions: index_table_actions
    }
  end
end
