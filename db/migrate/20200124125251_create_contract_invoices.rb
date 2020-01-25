class CreateContractInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_invoices do |t|
      t.belongs_to :contract
      t.string :contract_number, null: false
      t.datetime :issue_date, null: false
      t.datetime :due_date, null: false
      t.datetime :paid_date
      t.datetime :purchase_date, null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.decimal  :fixed_fee, precision: 8, scale: 2, null: false
      t.decimal  :additional_fee, precision: 8, scale: 2, null: false
      t.decimal  :total_fee, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
