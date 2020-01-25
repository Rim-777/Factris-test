require 'rails_helper'

RSpec.describe Contract, type: :model do
  it {should have_many(:invoices).class_name('Contract::Invoice').inverse_of(:contract).dependent(:destroy)}
end
