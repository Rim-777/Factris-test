require 'rails_helper'
RSpec.describe Api::V1::ContractsController do

  before do
    post '/api/contracts', params: params.to_json, headers: headers, xhr: true
  end

  describe 'POST create' do
    let(:headers) {Hash['Content-Type', 'application/json']}
    context 'success' do
      let(:params) do
        Hash[
            :contract, Hash[
            :number, 'A78',
            :start_date, '2020-03-01',
            :end_date, '2020-03-31',
            :fixed_fee_rate, 1.2,
            :additional_fee_rate, 0.02,
            :days_included, 14,
            :active, true]
        ]
      end

      it_behaves_like 'SuccessfulResponse'

      it 'returns json according to the schema' do
        expect(response).to match_response_schema('contract_post_success')
      end
    end

    context 'failure' do
      context 'missing required fields or value is invalid' do
        let(:params) do
          Hash[
              :contract, Hash[
              :number, nil,
              :start_date, nil,
              :end_date, '2020-03',
              :fixed_fee_rate, nil,
              :additional_fee_rate, nil,
              :days_included, -2,
              :active, nil]
          ]
        end

        it 'returns failure with  the unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'returns json according to the schema' do
          expect(response).to match_response_schema('contract_post_failure')
        end
      end

      context 'invalid data sequence' do
        let(:params) do
          Hash[
              :contract, Hash[
              :number, "A77",
              :start_date, '2020-01-31',
              :end_date, '2020-01-10',
              :fixed_fee_rate, 1.0,
              :additional_fee_rate, 0.2,
              :days_included, 5,
              :active, true]
          ]
        end

        it 'returns failure with  the unprocessable entity' do
          expect(response.status).to eq 422
        end

        it 'returns json according to the schema' do
          expect(response).to match_response_schema('contract_post_failure')
        end
      end
    end
  end
end
