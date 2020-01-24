class Contract < ApplicationRecord
  has_many :invoices,
           :class_name => 'Contract::Invoice',
           dependent: :destroy,
           inverse_of: :contract
end
