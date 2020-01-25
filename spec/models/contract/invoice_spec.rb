require 'rails_helper'

RSpec.describe Contract::Invoice, type: :model do
  it {should belong_to(:contract).inverse_of(:invoices).touch(true)}
end
