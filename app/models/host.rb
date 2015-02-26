class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences
  has_and_belongs_to_many :languages
  has_many :images, as: :imageable

  def email_to_username
  	email.gsub(/@.*/, "")
  end

end
