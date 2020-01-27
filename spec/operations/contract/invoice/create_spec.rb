require 'rails_helper'
RSpec.describe Contract::Invoice::Create do
  let(:operation) do
    Contract::Invoice::Create.(invoice_attributes)
  end

  let!(:a77_contract_1) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-01',
           end_date: '2020-03-15',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.4,
           days_included: 7,
           active: true
    )
  end

  let!(:a77_contract_3) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-16',
           end_date: '2020-03-28',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.6,
           days_included: 14,
           active: false
    )
  end

  context 'valid attributes' do
    context 'paid date is present' do
      let!(:a77_contract_7) do
        create(:contract,
               number: 'A77',
               start_date: '2020-03-16',
               end_date: nil,
               fixed_fee_rate: 1.2,
               additional_fee_rate: 0.02,
               days_included: 14,
               active: true
        )
      end

      let(:invoice_attributes) do
        Hash[
            :contract_number, 'A77',
            :issue_date, '2020-03-16',
            :purchase_date, '2020-03-16',
            :paid_date, '2020-04-08',
            :due_date, '2020-03-30',
            :amount, 1000
        ]
      end

      it_behaves_like 'InvoiceCreateSuccess'
    end

    context 'paid date is null' do
      let!(:a77_contract_7) do
        create(:contract,
               number: 'A77',
               start_date: 25.days.ago.to_date.to_s,
               end_date: 1.day.from_now.to_date.to_s,
               fixed_fee_rate: 1.2,
               additional_fee_rate: 0.02,
               days_included: 15,
               active: true
        )
      end

      let(:invoice_attributes) do
        Hash[
            :contract_number, 'A77',
            :issue_date, 25.days.ago.to_date.to_s,
            :purchase_date, 24.days.ago.to_date.to_s,
            :paid_date, nil,
            :due_date, 10.days.from_now.to_date.to_s,
            :amount, 1000
        ]
      end

      it_behaves_like 'InvoiceCreateSuccess'
    end
  end

  context 'invalid attributes' do
    context 'invalid contract number' do
      context 'missing key' do
        let(:invoice_attributes) do
          Hash[
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{contract_number: ['is missing']}}
        end
      end

      context 'missing value' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, nil,
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{contract_number: ['must be filled']}}
        end
      end

      context 'invalid type' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 2.333444777,
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{contract_number: ['must be a string']}}
        end
      end
    end

    context 'invalid issue_date date' do
      context 'missing key' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{issue_date: ['is missing']}}
        end
      end

      context 'missing value' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, nil,
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{issue_date: ['must be filled']}}
        end
      end

      context 'invalid format' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '20-20-12',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{issue_date: ['must be a date']}}
        end
      end
    end

    context 'invalid purchase_date' do
      context 'missing key' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{purchase_date: ['is missing']}}
        end
      end

      context 'missing value' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, nil,
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{purchase_date: ['must be filled']}}
        end
      end

      context 'invalid format' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{purchase_date: ['must be a date']}}
        end
      end
    end

    context 'invalid paid_date' do
      context 'invalid format' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-18',
              :paid_date, '2020-20-08',
              :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{paid_date: ['must be a date']}}
        end
      end
    end

    context 'invalid due_date' do
      context 'missing key' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              # :due_date, '2020-03-30',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{due_date: ['is missing']}}
        end
      end

      context 'missing value' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, nil,
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{due_date: ['must be filled']}}
        end
      end

      context 'invalid format' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-17',
              :paid_date, '2020-04-08',
              :due_date, '2020-03',
              :amount, 1000
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{due_date: ['must be a date']}}
        end
      end
    end

    context 'invalid  amount' do
      context 'missing key' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors) {{amount: ['is missing']}}
        end
      end

      context 'missing value' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-16',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-30',
              :amount, nil
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors){ {amount: ['must be filled']}}
        end
      end

      context 'invalid type' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-17',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-29',
              :amount, 'string'
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors){ {amount: ['must be a float']}}
        end
      end

      context 'is negative' do
        let(:invoice_attributes) do
          Hash[
              :contract_number, 'A77',
              :issue_date, '2020-03-16',
              :purchase_date, '2020-03-17',
              :paid_date, '2020-04-08',
              :due_date, '2020-03-29',
              :amount, -10
          ]
        end

        it_behaves_like 'InvalidInvoiceCreateOperation' do
          let(:errors){ {amount: ['must be greater than 0']}}
        end
      end
    end

    context 'contract is missing' do
      let(:invoice_attributes) do
        Hash[
            :contract_number, 'not existing number',
            :issue_date, '2020-03-16',
            :purchase_date, '2020-03-16',
            :paid_date, '2020-04-08',
            :due_date, '2020-03-30',
            :amount, 1000
        ]
      end

      it_behaves_like 'InvalidInvoiceCreateOperation' do
        let(:errors){ {contract: ['is missing or inactive']}}
      end
    end

    context 'contract is inactive' do
      let(:invoice_attributes) do
        Hash[
            :contract_number, 'A77',
            :issue_date, '2020-03-16',
            :purchase_date, '2020-03-16',
            :paid_date, '2020-04-08',
            :due_date, '2020-03-30',
            :amount, 1000
        ]
      end

      before {Contract.update_all(active: false)}

      it_behaves_like 'InvalidInvoiceCreateOperation' do
        let(:errors){ {contract: ['is missing or inactive']}}
      end
    end
  end
end
