class Contract::Invoice < ApplicationRecord
  belongs_to :contract, inverse_of: :invoices, touch: true
end
