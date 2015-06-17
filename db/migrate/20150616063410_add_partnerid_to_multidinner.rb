class AddPartneridToMultidinner < ActiveRecord::Migration
  def change
  	add_column :multidinners, :partner_id, :integer
  end
end
