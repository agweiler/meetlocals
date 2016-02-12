class Image < ActiveRecord::Base
  attr_reader :image_file_remote_url
  belongs_to :imageable, polymorphic: true

  has_attached_file :local_image,
                    path: "#{Rails.root}/tmp/:attachment_:id_:style_:basename.:extension",
                    url:  "/system/:attachment/:id/:style/:basename.:extension"
  validates_attachment :local_image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", ".png"] }

  has_attached_file :image_file,
										styles: { :medium => "300x300#", :thumb => "100x100>" , :host_party => "600x400#", :blogthumb => "300x188#"},
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
  after_commit :queue_upload_to_s3, on: [:create, :update], unless: :skip_callback

  def queue_upload_to_s3
        @id = local_image.instance.id
        ImageJob.new.perform(@id)
  end

  def upload_to_s3
  	#makes the image_file become the local_image file (paperclip method)
    self.image_file = Paperclip.io_adapters.for(self.local_image)
    @skip_callback = true
    save
  end


    def skip_callback
      @skip_callback
    end
end