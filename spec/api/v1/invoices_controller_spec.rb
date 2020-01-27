require 'rails_helper'
RSpec.describe Api::V1::InvoicesController do

  describe 'POST create' do
    let!(:a78_contract) do
      create(:contract,
             number: 'A78',
             start_date: '2020-03-01',
             end_date: '2020-03-29',
             fixed_fee_rate: 1.2,
             additional_fee_rate: 0.02,
             days_included: 14,
             active: true
      )
    end

    let(:headers) {Hash['Content-Type', 'application/json']}

    before do
      post '/api/invoices', params: params.to_json, headers: headers, xhr: true
    end

    context 'success' do
      let(:params) do
        Hash[
            :invoice, Hash[
            :contract_number, 'A78',
            :issue_date, '2020-03-02',
            :purchase_date, '2020-03-01',
            :paid_date, '2020-03-20',
            :due_date, '2020-04-30',
            :amount, 1000.0]
        ]
      end

      it_behaves_like 'SuccessfulResponse'

      it 'returns json according to the schema' do
        expect(response).to match_response_schema('invoice_post_success')
      end
    end

    context 'failure' do
      context 'missing required fields or value is invalid' do
        let(:params) do
          Hash[
              :invoice, Hash[
              :contract_number, nil,
              :issue_date, nil,
              :purchase_date, nil,
              :paid_date, '2020-03',
              :due_date, nil,
              :amount, -1000]
          ]
        end

        it_behaves_like 'FailureInvoice'
      end

      context 'missing contract' do
        let(:params) do
          Hash[
              :invoice, Hash[
              :contract_number, 'not existing number',
              :issue_date, '2020-03-02',
              :purchase_date, '2020-03-01',
              :paid_date, '2020-03-20',
              :due_date, '2020-04-30',
              :amount, 1000.0]
          ]
        end

        it_behaves_like 'FailureInvoice'
      end
    end
  end
end
