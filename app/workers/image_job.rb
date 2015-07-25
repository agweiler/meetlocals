class ImageJob
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(id)
    #image.id not found!!!! pass in through perform_async
    image_file = Image.find(id)
    image_file.upload_to_s3
    image_file.local_image.destroy
  end

  sidekiq_retry_in do |count|
    1 * (count + 1) # (i.e. 10, 20, 30, 40)
  end
end