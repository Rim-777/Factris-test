NewContractInvoiceSchema = Dry::Validation.Schema do
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

  required(:contract_number).filled(:str?)
  required(:issue_date).filled(:str?, :date?)
  required(:due_date).filled(:str?, :date?)
  optional(:paid_date).maybe(:str?, :date?)
  required(:purchase_date).filled(:str?, :date?)
  required(:amount).filled(:float?)
end
