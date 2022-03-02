# frozen_string_literal: true

class AccountPlanDecorator < PlanBaseDecorator
  def index_table_data
    {
      id: id,
      name: name,
      editPath: h.edit_polymorphic_path([:admin, object]),
      contracts: contracts_count,
      contractsPath: h.admin_buyers_accounts_path(search: { plan_id: id }),
      state: state,
      actions: index_table_actions
    }
  end
end
