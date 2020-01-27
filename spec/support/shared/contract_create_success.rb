shared_examples_for 'ContractCreateSuccess' do
  it 'returns success' do
    expect(operation).to be_success
  end

  it 'stores a new contract to the database' do
    expect {operation}.to change(Contract, :count).by(1)
  end
end