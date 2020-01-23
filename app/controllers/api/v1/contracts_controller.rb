module Api::V1
  class ContractsController < BaseController

    def create
      operation = Contract::Create.(contract_params)
      if operation.success?
        render json: operation[:result], serializer: ContractSerializer, status: :created
      else
        render json: operation[:errors], status: 422
      end
    end

    def contract_params
      params.require(:contract).permit(
          :number,
          :start_date,
          :end_date,
          :fixed_fee_rate,
          :additional_fee_rate,
          :days_included,
          :active
      )
    end
  end
end
