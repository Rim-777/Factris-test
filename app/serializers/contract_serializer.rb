class ContractSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :start_date,
             :end_date,
             :fixed_fee_rate,
             :additional_fee_rate,
             :days_included,
             :active
end
