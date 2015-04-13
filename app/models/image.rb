class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image_file,

  styles: { :medium => "300x300!", :thumb => "100x100>" } #you can customise the storage path here using :path

  # validates_attachment_content_type :image_file, content_type: /\Aimage\/.*\Z/
  # need to define these according to the size they will be displayed on site. 
  # host/avatar sizes ok
  # experience show top images should be longer... aspect ratio will be 4:5 maybe?

  validates_attachment :image_file, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
end	
