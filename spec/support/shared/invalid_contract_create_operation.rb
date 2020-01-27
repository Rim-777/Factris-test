shared_examples_for 'InvalidContractCreateOperation' do
  it 'returns success' do
    expect(operation).to be_failure
  end

  it "doesn't store a new contract to the database" do
    expect {operation}.to_not change(Contract, :count)
  end

  it 'adds an error message to the operation error list' do
    operation
    expect(operation[:errors]).to eq(errors)
  end
end