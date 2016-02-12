class RemoveIsHalalFromExperiences < ActiveRecord::Migration
  def self.up
      remove_column :experiences, :is_halal
  end

  def self.down
    change_table :experiences do |t|
      t.boolean :is_halal
    end
  end
end
