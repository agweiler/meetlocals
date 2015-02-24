class Image < ActiveRecord::Base
  belongs_to :imageable, ploymorphic: true
end
