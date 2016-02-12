class AddBankStuffToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :bank_name, :string
    add_column :hosts, :bank_number, :string
    add_column :hosts, :registration_number, :string
  end
end
