shared_examples_for 'ContractCreateWithSupersede' do

  it_behaves_like 'ContractCreateSuccess'

  it 'makes overlapped contracts inactive' do
    operation
    expect(a77_contract_1.reload.active?).to be_falsey
    expect(a77_contract_2.reload.active?).to be_falsey
    expect(a77_contract_3.reload.active?).to be_falsey
    expect(a77_contract_4.reload.active?).to be_falsey
    expect(a77_contract_5.reload.active?).to be_falsey
    expect(a77_contract_6.reload.active?).to be_falsey
  end

  it 'correctly assigns data' do
    operation
    expect(operation[:result].number).to eq(contract_attributes[:number])
    expect(operation[:result].start_date).to eq(contract_attributes[:start_date])
    expect(operation[:result].end_date).to eq(contract_attributes[:end_date])
    expect(operation[:result].fixed_fee_rate).to eq(contract_attributes[:fixed_fee_rate])
    expect(operation[:result].additional_fee_rate).to eq(contract_attributes[:additional_fee_rate])
    expect(operation[:result].days_included).to eq(contract_attributes[:days_included])
    expect(operation[:result].active).to eq(contract_attributes[:active])
  end


  it "does't change other contracts" do
    operation
    expect(a78_contract.reload.active?).to be_truthy
  end
end