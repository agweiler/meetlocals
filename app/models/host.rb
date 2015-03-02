class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences
  has_and_belongs_to_many :languages
  has_many :images, as: :imageable
  acts_as_messageable

  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def mailboxer_email(object)
  #Check if an email should be sent for that object
  #if true
  return nil
  #if false
  #return nil
  end

  def name
    username
  end
end
