class Post < ActiveRecord::Base
	belongs_to :admin
	validates :title, presence: true
	validates :body,  presence: true
	has_many :images, as: :imageable
	before_save :sanitize

	private

	def sanitize
		self.body = Sanitize.fragment(self.body,
  :elements => ['br','b','i','strong','u','small','a'],

  :attributes => {
    'a'    => ['href', 'title','target'],
  })
	end
end
