# frozen_string_literal: true

class Api::PlanCopiesController < FrontendController
  before_action :find_plan
  before_action :find_service
  before_action :authorize_section, only: %i[new create]
  before_action :authorize_action, only: %i[new create]

  def new; end

  def create
    @plan = @original.copy(params[@type] || {})

    if @plan.save
      # TODO: DRY this in model
      @plans = @issuer.send("#{@type}s").reload.not_custom

      @new_plan = @plan.class
    end

    respond_to do |format|
      json = @plan.persisted? ? { notice: 'Plan copied.' } : { error: 'Plan could not be copied' }
      json[:plan] = @plan.decorate.index_table_data.to_json
      format.json { render json: json, status: :created }
    end
  end

  private

  def find_plan
    @original = current_account.provided_plans.find(params[:plan_id])
    @type = @original.class.to_s.underscore
    @issuer = @original.issuer
  end

  def find_service
    return unless @original.respond_to?(:service)
    @service = current_user.accessible_services.find(@original.issuer_id)
  end

  def authorize_section
    authorize! :manage, :plans
  end

  def authorize_action
    authorize! :create, :plans
  end
end
