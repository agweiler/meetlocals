class ExpImageJob
  require 'open-uri'
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(id)
    puts "------------------------------"
    puts "backgroundjob starts! for #{id}"
    puts "------------------------------"
    image = Image.find(id)
    url = image.temp_file_key
    puts "_______________________________"
    puts "Url is #{url}"
    puts "_______________________________"
    image.image_file_remote_url = url
  end

  sidekiq_retry_in do |count|
   1 * (count + 1) # (i.e. 10, 20, 30, 40)
  end
end