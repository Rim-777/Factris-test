require "trailblazer/operation"
class Contract::Create < Trailblazer::Operation
  step :validate_attributes
  step :validate_date_sequence
  step :init_new_contract
  step :create_and_supersede

  private

  def validate_attributes(options, params)
    validation = NewContractSchema.(params.to_h)
    validation_success = validation.success?
    options[:errors] = validation.errors unless validation_success
    validation_success
  end

  def validate_date_sequence(options, params)
    return true unless end_date = params[:end_date]
    sequence_valid = end_date.to_date >= params[:start_date].to_date
    options[:errors] = {error: I18n.t('errors.date_sequence')} unless sequence_valid
    sequence_valid
  end

  def init_new_contract(options, params)
    @new_contract = Contract.new(params)
  end

  def create_and_supersede(options, params)
    Contract.transaction do
      overlapped_contracts.each do |contract|
        contract.lock!
        contract.update!(active: false)
      end
      @new_contract.save!
    end
    options[:result] = @new_contract
  end

  def overlapped_contracts
    return Array.new unless @new_contract.active?
    @new_contract.end_date.nil? ? overlapped_for_infinite : overlapped_for_regular
  end

  def overlapped_for_infinite
    contract_number = @new_contract.number
    Contract
        .where(number: contract_number, active: true)
        .where('end_date IS NULL')
        .or(
            Contract
                .where(number: contract_number, active: true)
                .where('end_date IS NOT NULL')
                .where('end_date >= ?', @new_contract.start_date)
        )
  end

  def overlapped_for_regular
    contract_number = @new_contract.number
    new_contract_start_date = @new_contract.start_date
    new_contract_end_date = @new_contract.end_date
    Contract.where(number: contract_number, active: true)
        .where('end_date IS NULL AND start_date <= ?', new_contract_end_date)
        .or(
            Contract.where(number: contract_number, active: true)
                .where('end_date IS NOT NULL')
                .where('(start_date <= ? AND end_date >= ?) OR
                        (start_date <= ? AND end_date >= ?) OR
                        (start_date >= ? AND end_date <= ?)',
                       new_contract_start_date,
                       new_contract_start_date,
                       new_contract_end_date,
                       new_contract_end_date,
                       new_contract_start_date,
                       new_contract_end_date
                )
        )
  end
end
