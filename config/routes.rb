Rails.application.routes.draw do
  api vendor_string: "factris", default_version: 1 do
    version 1 do
      cache as: 'v1' do
        resource :contracts, only: [:create]
        resource :invoices, only: [:create]
      end
    end
  end
end
