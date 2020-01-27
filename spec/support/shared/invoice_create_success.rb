shared_examples_for 'InvoiceCreateSuccess' do
  it 'returns success' do
    expect(operation).to be_success
  end

  it 'stores a new invoice to the database' do
    expect {operation}.to change(Contract::Invoice, :count).by(1)
  end

  it 'relates the new invoice to the right contract' do
    expect {operation}.to change(a77_contract_7.invoices, :count).by(1)
  end

  it 'correctly assigns data' do
    operation
    expect(a77_contract_7.invoices.first.contract_number).to eq(invoice_attributes[:contract_number])
    expect(a77_contract_7.invoices.first.issue_date).to eq(invoice_attributes[:issue_date])
    expect(a77_contract_7.invoices.first.purchase_date).to eq(invoice_attributes[:purchase_date])
    expect(a77_contract_7.invoices.first.paid_date).to eq(invoice_attributes[:paid_date])
    expect(a77_contract_7.invoices.first.due_date).to eq(invoice_attributes[:due_date])
    expect(a77_contract_7.invoices.first.amount).to eq(invoice_attributes[:amount])
  end

  it 'assigns created invoice as an operation result' do
    operation
    expect(operation[:result]).to eq(a77_contract_7.invoices.first)
  end

  it 'correctly calculates fees' do
    operation
    expect(a77_contract_7.invoices.first.fixed_fee).to eq(12.0)
    expect(a77_contract_7.invoices.first.additional_fee).to eq(2.0)
    expect(a77_contract_7.invoices.first.total_fee).to eq(14.0)
  end
end
