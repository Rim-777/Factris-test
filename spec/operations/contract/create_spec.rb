require 'rails_helper'
RSpec.describe Contract::Create do
  let(:operation) do
    Contract::Create.(contract_attributes)
  end

  let!(:a77_contract_1) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-01',
           end_date: '2020-03-15',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 7,
           active: true
    )
  end

  let!(:a77_contract_2) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-29',
           end_date: '2020-04-15',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  let!(:a77_contract_3) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-16',
           end_date: '2020-03-28',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  let!(:a77_contract_4) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-14',
           end_date: '2020-03-31',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  let!(:a77_contract_5) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-14',
           end_date: nil,
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  let!(:a77_contract_6) do
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

  let!(:a77_contract_7) do
    create(:contract,
           number: 'A77',
           start_date: '2020-03-01',
           end_date: '2020-03-14',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  let!(:a78_contract) do
    create(:contract,
           number: 'A78',
           start_date: '2020-03-16',
           end_date: '2020-03-29',
           fixed_fee_rate: 1.2,
           additional_fee_rate: 0.02,
           days_included: 14,
           active: true
    )
  end

  context 'valid attributes' do
    context 'infinite contract' do
      let(:contract_attributes) do
        Hash[
            :number, 'A77',
            :start_date, '2020-03-15',
            :end_date, nil,
            :fixed_fee_rate, 1.2,
            :additional_fee_rate, 1.2,
            :days_included, 14,
            :active, true
        ]
      end

      it 'returns success' do
        expect(operation).to be_success
      end

      it 'stores a new contract to the database' do
        expect {operation}.to change(Contract, :count).by(1)
      end

      it 'makes overlapped contracts inactive' do
        operation
        expect(a77_contract_1.reload.active?).to be_falsey
        expect(a77_contract_2.reload.active?).to be_falsey
        expect(a77_contract_3.reload.active?).to be_falsey
        expect(a77_contract_4.reload.active?).to be_falsey
        expect(a77_contract_5.reload.active?).to be_falsey
        expect(a77_contract_6.reload.active?).to be_falsey
      end

      it "does't change not overlapped contracts" do
        operation
        expect(a77_contract_7.reload.active?).to be_truthy
      end

      it "does't change other contracts" do
        operation
        expect(a78_contract.reload.active?).to be_truthy
      end
    end

    context 'end date present' do
      let(:contract_attributes) do
        Hash[
            :number, 'A77',
            :start_date, '2020-03-15',
            :end_date, '2020-03-30',
            :fixed_fee_rate, 1.2,
            :additional_fee_rate, 1.2,
            :days_included, 14,
            :active, true
        ]
      end

      let!(:a77_contract_8) do
        create(:contract,
               number: 'A77',
               start_date: '2020-03-31',
               end_date: '2020-04-14',
               fixed_fee_rate: 1.2,
               additional_fee_rate: 0.02,
               days_included: 14,
               active: true
        )
      end

      let!(:a77_contract_9) do
        create(:contract,
               number: 'A77',
               start_date: '2020-03-31',
               end_date: nil,
               fixed_fee_rate: 1.2,
               additional_fee_rate: 0.02,
               days_included: 14,
               active: true
        )
      end

      it 'returns success' do
        expect(operation).to be_success
      end

      it 'stores a new contract to the database' do
        expect {operation}.to change(Contract, :count).by(1)
      end

      it 'makes overlapped contracts inactive' do
        operation
        expect(a77_contract_1.reload.active?).to be_falsey
        expect(a77_contract_2.reload.active?).to be_falsey
        expect(a77_contract_3.reload.active?).to be_falsey
        expect(a77_contract_4.reload.active?).to be_falsey
        expect(a77_contract_5.reload.active?).to be_falsey
        expect(a77_contract_6.reload.active?).to be_falsey
      end

      it "does't change not overlapped contracts" do
        operation
        expect(a77_contract_7.reload.active?).to be_truthy
        expect(a77_contract_8.reload.active?).to be_truthy
        expect(a77_contract_9.reload.active?).to be_truthy
      end

      it "does't change other contracts" do
        operation
        expect(a78_contract.reload.active?).to be_truthy
      end
    end

    context 'contract initially inactive' do
      let(:contract_attributes) do
        Hash[
            :number, 'A77',
            :start_date, '2020-03-15',
            :end_date, '2020-03-30',
            :fixed_fee_rate, 1.2,
            :additional_fee_rate, 1.2,
            :days_included, 14,
            :active, false
        ]
      end

      it 'returns success' do
        expect(operation).to be_success
      end

      it 'stores a new contract to the database' do
        expect {operation}.to change(Contract, :count).by(1)
      end

      it "doesn't make overlapped contracts inactive" do
        operation
        expect(a77_contract_1.reload.active?).to be_truthy
        expect(a77_contract_2.reload.active?).to be_truthy
        expect(a77_contract_3.reload.active?).to be_truthy
        expect(a77_contract_4.reload.active?).to be_truthy
        expect(a77_contract_5.reload.active?).to be_truthy
        expect(a77_contract_6.reload.active?).to be_truthy
      end
    end
  end

  context 'invalid attributes' do
    context 'invalid number' do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({number: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, nil,
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end


        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({number: ['must be filled']})
        end
      end

      context 'invalid type' do
        let(:contract_attributes) do
          Hash[
              :number, 12345678,
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({number: ['must be a string']})
        end
      end
    end

    context 'invalid start date' do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :number, 'A77',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({start_date: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, nil,
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({start_date: ['must be filled']})
        end
      end

      context 'invalid format' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '202003s15wew',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({start_date: ['must be a date']})
        end
      end
    end

    context 'invalid end date' do
      context 'invalid format' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, 'INWALIDDATE',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({end_date: ['must be a date']})
        end
      end
    end

    context 'invalid fixed fee rate' do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :number, 'A77',
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              # :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({fixed_fee_rate: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, nil,
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({fixed_fee_rate: ['must be filled']})
        end
      end

      context 'invalid type' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, "string",
              :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({fixed_fee_rate: ['must be a float']})
        end
      end
    end

    context 'invalid additional fee rate' do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :number, 'A77',
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              # :additional_fee_rate, 1.2,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({additional_fee_rate: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1,
              :additional_fee_rate, nil,
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({additional_fee_rate: ['must be filled']})
        end
      end

      context 'invalid type' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 2,
              :additional_fee_rate, "string",
              :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({additional_fee_rate: ['must be a float']})
        end
      end
    end

    context 'invalid "days included"' do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :number, 'A77',
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              # :days_included, 14,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({days_included: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1,
              :additional_fee_rate, 2,
              :days_included, nil,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({days_included: ['must be filled']})
        end
      end

      context 'invalid type' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 2,
              :additional_fee_rate, 2,
              :days_included, 14.2323232323232,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({days_included: ['must be an integer']})
        end
      end

      context 'negative number' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 2,
              :additional_fee_rate, 2,
              :days_included, -2,
              :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({days_included: ['must be greater than or equal to 0']})
        end
      end
    end

    context "invalid field 'active'" do
      context 'missing key' do
        let(:contract_attributes) do
          Hash[
              :number, 'A77',
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1.2,
              :additional_fee_rate, 1.2,
              :days_included, 14,
          # :active, true
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({active: ['is missing']})
        end
      end

      context 'missing value' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 1,
              :additional_fee_rate, 2,
              :days_included, 10,
              :active, nil
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({active: ['must be filled']})
        end
      end

      context 'invalid type' do
        let(:contract_attributes) do
          Hash[
              :number, "A77",
              :start_date, '2020-03-15',
              :end_date, '2020-03-30',
              :fixed_fee_rate, 2,
              :additional_fee_rate, 2,
              :days_included, 10,
              :active, "string"
          ]
        end

        it 'returns success' do
          expect(operation).to be_failure
        end

        it "doesn't store a new contract to the database" do
          expect {operation}.to_not change(Contract, :count)
        end

        it 'adds an error message to the operation error list' do
          operation
          expect(operation[:errors]).to eq({active: ['must be boolean']})
        end
      end
    end
  end

  context 'invalid sequence' do
    let(:contract_attributes) do
      Hash[
          :number, "A77",
          :start_date, '2020-03-31',
          :end_date, '2020-03-30',
          :fixed_fee_rate, 2,
          :additional_fee_rate, 2,
          :days_included, 10,
          :active, true
      ]
    end

    it 'returns success' do
      expect(operation).to be_failure
    end

    it "doesn't store a new contract to the database" do
      expect {operation}.to_not change(Contract, :count)
    end

    it 'adds an error message to the operation error list' do
      operation
      expect(operation[:errors]).to eq({dates_sequence: ["End date can't be earlier than start date"]})
    end
  end
end
