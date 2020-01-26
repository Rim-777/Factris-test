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

  def amount
    object.amount.to_f
  end

  def fixed_fee
    object.fixed_fee.to_f
  end

  def additional_fee
    object.additional_fee.to_f
  end

  def total_fee
    object.total_fee.to_f
  end
end
