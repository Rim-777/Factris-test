shared_examples_for 'FailureInvoice' do

  it_behaves_like 'UnprocessableEntity'

  it 'returns json according to the schema' do
    expect(response).to match_response_schema('invoice_post_failure')
  end
end