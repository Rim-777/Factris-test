shared_examples_for 'InvalidInvoiceCreateOperation' do
  it 'returns failure' do
    expect(operation).to be_failure
  end

  it "doest't store any invoices to the database" do
    expect {operation}.to_not change(Contract::Invoice, :count)
  end

  it 'adds an error message to the operation errors' do
    operation
    expect(operation[:errors]).to eq(errors)
  end
end