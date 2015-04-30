class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences

  has_many :images, as: :imageable
  # removed uniqueness constraint
  # validates_uniqueness_of :username - not needed because of devise validatable
  validates :images, presence: true

  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def age
    now = Time.now.utc.to_date
    dob = self.DOB
    return nil if dob.nil?
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
