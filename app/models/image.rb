class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :local_image,
                    path: ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
                    url:  "/system/:attachment/:id/:style/:basename.:extension"

  has_attached_file :image_file,
										styles: { :medium => "300x300!", :thumb => "100x100>" }, #you can customise the storage path here using :path
										:storage => :s3,
          					:s3_credentials => {
            				# :bucket => ENV['AWS_BUCKET'],
            				# :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
            				# :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
            				:bucket => 'mtdimagesdev',
            				:access_key_id => 'AKIAJ3P3LCTBF7SD2ORQ',
            				:secret_access_key => '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'
          					},
          					:path => ":class/:id/:basename_:style.:extension",
          					:url => ":s3_sg_url"

  # validates_attachment_content_type :image_file, content_type: /\Aimage\/.*\Z/
  # need to define these according to the size they will be displayed on site. 
  # host/avatar sizes ok
  # experience show top images should be longer... aspect ratio will be 4:5 maybe?

  validates_attachment :image_file, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

    after_save :queue_upload_to_s3

  def queue_upload_to_s3
    Delayed::Job.enqueue ImageJob.new(id) if local_image? && local_image_updated_at_changed?
  end

  def upload_to_s3
    self.image_file= local_image.to_file
    save!
  end
end

class ImageJob < Struct.new(:image_id)
  def perform
    image_file = Image.find image_id
    image_file.upload_to_s3
    image_file.local_image.destroy
  end
end	
