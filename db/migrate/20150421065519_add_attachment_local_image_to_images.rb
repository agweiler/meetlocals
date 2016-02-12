class AddAttachmentLocalImageToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :local_image
    end
  end

  def self.down
    remove_attachment :images, :local_image
  end
end
