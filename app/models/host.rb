class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences
  has_many :images, as: :imageable

  has_many :bookings
  has_many :bookings, through: :experiences
  has_many :testimonials
  has_many :testimonials, through: :bookings
  has_many :holidays
  # removed uniqueness constraint
  # validates_uniqueness_of :username - not needed because of devise validatable


  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def age
    now = Time.now.utc.to_date
    dob = self.dob
    return nil if dob.nil?
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def avg_rating
    self.testimonials.average(:rating).round(2)
  end

  def holidays_list
    # self.holidays.map { |holiday| holiday.date.strftime('%D') } # 05/19/15
    self.holidays.map { |holiday| holiday.date.strftime('%F') } # 2015-05-19
  end

  def smoker?
    if self.smoker == true
      return "Smoker"
    else
      nil
    end
  end

  def set_holiday(dates)
    return false if dates.blank?
    self.holidays.destroy_all

    dates.split(',').each do |date|
      holiday = self.holidays.new(date:date.strip)
      holiday.save
    end
    true
  end

end
