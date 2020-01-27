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

  it "does't change other contracts" do
    operation
    expect(a78_contract.reload.active?).to be_truthy
  end
end