class CreateContracts < ActiveRecord::Migration[6.0]
  def change
      create_table :contracts do |t|
        t.string :number, null: false
        t.datetime :start_date, null: false
        t.datetime :end_date
        t.decimal :fixed_fee_rate, precision: 8, scale: 4, null: false
        t.decimal :additional_fee_rate, precision: 8, scale: 4, null: false
        t.integer :days_included, null: false
        t.boolean :active, null: false
        t.index([:number, :active, :start_date, :end_date],
                name: 'indexContractsOnNumber&Active&StartDate&EndDate')
        t.timestamps
      end
  end
end
