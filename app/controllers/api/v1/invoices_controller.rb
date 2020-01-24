module Api::V1
  class InvoicesController < BaseController

    def create
      operation = Contract::Invoice::Create.(invoice_params)
      if operation.success?
        render json: operation[:result], serializer: Contract::InvoiceSerializer, status: :created
      else
        render json: operation[:errors], status: 422
      end
    end

    def invoice_params
      params.require(:invoice).permit(
          :contract_number,
          :issue_date,
          :due_date,
          :paid_date,
          :purchase_date,
          :amount
      )
    end
  end
end
