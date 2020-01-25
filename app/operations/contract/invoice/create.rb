require "trailblazer/operation"
class Contract::Invoice::Create < Trailblazer::Operation
  step :validate_attributes
  step :fetch_contract
  step :set_invoice
  step :calculate_fees

  private

  def validate_attributes(options, params)
    validation = NewContractInvoiceSchema.(params.to_h)
    validation_success = validation.success?
    options[:errors] = validation.errors unless validation_success
    validation_success
  end

  def fetch_contract(options, params)
    issue_date = params[:issue_date]
    @contract = Contract
                    .where(number: params[:contract_number], active: true)
                    .where('start_date <= ?', issue_date)
                    .where('end_date IS NULL OR end_date >= ?', issue_date).first
    contract_present = @contract.present?
    options[:errors] = {error: I18n.t('errors.missing_contract')} unless contract_present
    contract_present
  end

  def set_invoice(options, params)
    @invoice = @contract.invoices.new(params)
  end

  def calculate_fees(options, params)
    invoice_amount = @invoice.amount
    fixed_fee_period_end = @invoice.purchase_date.to_date + @contract.days_included
    additional_fee_period = (fixed_fee_period_end..(@invoice.paid_date.try(:to_date) || Date.today)).count
    @invoice.fixed_fee = @contract.fixed_fee_rate / 100 * invoice_amount
    @invoice.additional_fee = @contract.additional_fee_rate / 100 * additional_fee_period * invoice_amount
    @invoice.total_fee = @invoice.fixed_fee + @invoice.additional_fee
    @invoice.save!
    options[:result] = @invoice
  end

end
