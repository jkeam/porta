# frozen_string_literal: true

# TODO: DRY this from other plans presenters
class Api::ServicePlansPresenter
  include System::UrlHelpers.system_url_helpers

  def initialize(service:, collection:, params: {})
    @service = service
    @collection = collection
    @pagination_params = { page: params[:page] || 1, per_page: params[:per_page] || 20 }
    @search = ThreeScale::Search.new(params[:search])
    @sorting_params = "#{params[:sort].presence || 'name'} #{params[:direction].presence || 'asc'}"
  end

  attr_reader :service, :collection, :pagination_params, :search, :sorting_params

  def paginated_plans
    @paginated_plans ||= plans.paginate(pagination_params)
  end

  def default_service_plan_data
    {
      'plans': plans.to_json(root: false, only: %i[id name]),
      'current-plan': service.default_service_plan&.to_json(root: false, only: %i[id name]) || nil.to_json,
      'path': masterize_admin_service_service_plans_path(service)
    }
  end

  def service_plans_table_data
    {
      columns: columns.to_json,
      plans: paginated_plans.decorate.map(&:index_table_data).to_json,
      count: paginated_plans.total_entries,
      'search-href': admin_service_service_plans_path(service)
    }
  end

  private

  def columns
    [
      { attribute: :name, title: ServicePlan.human_attribute_name(:name) },
      { attribute: :contracts_count, title: ServicePlan.human_attribute_name(:contracts) },
      { attribute: :state, title: ServicePlan.human_attribute_name(:state) }
    ]
  end

  def plans
    @plans ||= collection.not_custom
                         .reorder(sorting_params)
                         .scope_search(search)
  end
end
