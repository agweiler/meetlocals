class CreateJoinTableHostLanguage < ActiveRecord::Migration
  def change
    create_join_table :hosts, :languages do |t|
      # t.index [:host_id, :language_id]
      # t.index [:language_id, :host_id]
    end
  end
end
