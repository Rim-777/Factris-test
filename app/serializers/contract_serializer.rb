class ContractSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :start_date,
             :end_date,
             :fixed_fee_rate,
             :additional_fee_rate,
             :days_included,
             :active

  def fixed_fee_rate
    object.fixed_fee_rate.to_f
  end

  def additional_fee_rate
    object.additional_fee_rate.to_f
  end

  def start_date
    object.start_date.to_date
  end

  def end_date
    object.end_date.to_date
  end
end
