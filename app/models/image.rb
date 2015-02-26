class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image_file, styles: { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :image_file, content_type: /\Aimage\/.*\Z/
end
