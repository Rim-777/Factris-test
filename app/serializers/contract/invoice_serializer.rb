class Contract::InvoiceSerializer < ActiveModel::Serializer
  attributes :id,
             :contract_number,
             :issue_date,
             :purchase_date,
             :paid_date,
             :due_date,
             :amount,
             :fixed_fee,
             :additional_fee,
             :total_fee

end
