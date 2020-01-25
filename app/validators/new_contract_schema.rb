NewContractSchema = Dry::Validation.Schema do
  configure do
    def date?(value)
      Date.parse(value)
    rescue ArgumentError
      false
    end

    def float?(value)
      value.is_a?(Float) || value.is_a?(Integer)
    end
  end

  required(:number).filled(:str?)
  required(:start_date).filled(:str?, :date?)
  optional(:end_date).maybe(:str?, :date?)
  required(:fixed_fee_rate).filled(:float?)
  required(:additional_fee_rate).filled(:float?)
  required(:days_included).filled(:int?, gteq?: 0)
  required(:active).filled(:bool?)
end