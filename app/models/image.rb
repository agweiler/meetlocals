class Image < ActiveRecord::Base

  belongs_to :imageable, polymorphic: true

  has_attached_file :local_image,
                    path: "#{Rails.root}/tmp/:attachment_:id_:style_:basename.:extension",
                    url:  "/system/:attachment/:id/:style/:basename.:extension"
  validates_attachment :local_image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", ".png"] }

  has_attached_file :image_file,
										styles: { :medium => "300x300!", :thumb => "100x100>" , :host_party => "600x400!", :blogthumb => "300x188!"},
                    #you can customise the storage path here using :path
										:storage => :s3,
          					:s3_credentials => {
            				:bucket => ENV['AWS_BUCKET'],
            				:access_key_id => ENV['AWS_ACCESS_KEY_ID'],
            				:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
          					},
          					:path => ":class/:id/:basename_:style.:extension",
          					:url => ":s3_sg_url"

  # validates_attachment_content_type :image_file, content_type: /\Aimage\/.*\Z/
  # need to define these according to the size they will be displayed on site.
  # host/avatar sizes ok
  # experience show top images should be longer... aspect ratio will be 4:5 maybe?

  validates_attachment :image_file, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", ".png"] }
  after_commit :queue_upload_to_s3

  process_in_background :image_file

  def queue_upload_to_s3
     if local_image.instance.imageable_type == "Experience" 
       puts "__________________________________________________"
       puts "everything starts here image id is #{self.id}"
       puts "__________________________________________________"
       if local_image_file_name == nil
         puts "__________________________________________________"
         puts "Next step for #{self.id}"
         puts "the tmpe key is #{self.temp_file_key}"
         puts "__________________________________________________"
         image_file_remote_url = temp_file_key
         puts "does #{self.id} it reach here?"
       end
    else
      if local_image? && local_image_updated_at_changed?
        @id = local_image.instance.id
        ImageJob.new.perform(@id)
      end
    end
    puts "or does #{self.id} go here?"
  end

  def upload_to_s3
  	#makes the image_file become the local_image file (paperclip method)
    puts "__________________________________________________"
    puts "It enters this method"
    puts "the url of image_file is #{self.image_file.url}"
    puts "__________________________________________________"
    self.image_file = Paperclip.io_adapters.for(self.local_image)
    puts "__________________________________________________"
    puts "the url of image_file is #{self.image_file.url}"
    puts "__________________________________________________"
    save!
  end

  def image_file_remote_url=(url_value)
    self.image_file = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # image_file_file_name == "face.png"
    # image_file_content_type == "image/png"
    @image_file_remote_url = url_value
  end
end