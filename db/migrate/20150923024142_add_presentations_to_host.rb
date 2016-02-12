class AddPresentationsToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :host_presentation, :string
  end
end
