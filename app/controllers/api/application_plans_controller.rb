# frozen_string_literal: true

class Api::ApplicationPlansController < Api::PlansBaseController
  before_action :activate_sidebar_menu

  activate_menu :serviceadmin, :applications, :application_plans
  sublayout 'api/service'

  helper_method :default_application_plan_data, :application_plans_table_data
  delegate :default_application_plan_data, :application_plans_table_data, to: :presenter

  alias application_plans plans

  def index
    @new_plan = ApplicationPlan
  end

  def new
    @plan = collection.build params[:application_plan]
  end

  def edit
    @plan = collection.includes(:plan_metrics, :usage_limits, :pricing_rules, service: :top_level_metrics).find(params[:id])
  end

  # class super metod which is Api::PlansBaseController#create
  # to create plan same way as all plans
  #
  def create
    super(application_plan_params)
  end

  def update
    super(application_plan_params)
  end

  # rubocop:disable Lint/UselessMethodDefinition
  def destroy
    super
  end
  # rubocop:enable Lint/UselessMethodDefinition

  def masterize
    assign_plan!(@service, :default_application_plan)
  end

  protected

  # TODO: leave or delete? When is it current_account the scope?
  def scope
    @service || current_account
  end

  def collection
    @collection ||= scope.application_plans.includes(:issuer)
  end

  def activate_sidebar_menu
    activate_menu :sidebar => :application_plans
  end

  def application_plan_params
    params.require(:application_plan).permit(:name, :system_name, :description, :rights, :approval_required, :trial_period_days, :cost_per_month, :setup_fee)
  end

  def presenter
    @presenter ||= Api::ApplicationPlansPresenter.new(service: @service, collection: collection, params: params)
  end
end
