class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :experiences, dependent: :destroy
  has_many :images, as: :imageable
  has_many :notifications
  has_many :bookings, dependent: :destroy
  has_many :bookings, through: :experiences
  has_many :testimonials, dependent: :destroy
  has_many :testimonials, through: :bookings
  has_many :holidays

  scope :in_holiday,
   -> (date) { joins(:holidays).where("holidays.date = ?", date) }

  scope :has_booking,
   -> (date) { joins(:bookings).where("bookings.date = ? AND status = 'confirmed'", date) }
  # scope :not_holiday,
  #  -> (date) { joins(:holidays).where("holidays.date <> ?", date) }
  scope :from_state, -> (location) { where("state = ?", location) }


  # removed uniqueness constraint
  # validates_uniqueness_of :username - not needed because of devise validatable

  def email_to_username
  	email.gsub(/@.*/, "").capitalize
  end

  def self.age_ranges
    ['Age', '20-35', '36-50', '51-65', '66+']
  end

  def self.dob_ranges
    [Date.new(1800)                 .. Date.today,
     Date.new(Date.today.year - 35) .. Date.new((Date.today.year - 20), 12, 31),
     Date.new(Date.today.year - 50) .. Date.new((Date.today.year - 36), 12, 31),
     Date.new(Date.today.year - 65) .. Date.new((Date.today.year - 51), 12, 31),
     Date.new(1800)                 .. Date.new((Date.today.year - 66), 12, 31)]
  end

  def self.search(low, high, loc, group, date) #low_age, high_age, etc..
    high ||= 200 #66+
    young = Date.today.year - low.to_i #20 -> 1995
    old = Date.today.year - high.to_i #35 -> 1980

    lower_range = Date.new(  old, 01, 01 ) #1980.1.1
    upper_range = Date.new(young, 12, 31 ) #1995.12.31
    age = "dob >= '#{lower_range}' AND dob <= '#{upper_range}'"

    loc == "Location" ? loc = '' : loc = " AND state = '#{loc}'"
    group == "Guests" ? group = "" : group = " AND experiences.max_group_size >= #{group} AND experiences.date IS NULL"

    # between [ >=] 1980.1.1 and [<= ] 1995.12.31
    # Host.where('dob >= ? AND dob <= ? ?', lower_range, upper_range, loc)

    # Host.joins(:experiences).where(age + loc + group).uniq.map do |host|
    #   host if host.free?(date.to_date)
    # end.compact
    if date.blank?
      # Host.joins(:experiences).where(age + loc + group).uniq
      host_in = " AND hosts.id IN(#{Experience.pluck('host_id').uniq.join(',')})"
    else
      # Host.joins(:experiences).where(age + loc + group).not_holiday(date).uniq
      free_hosts = Experience.pluck('host_id').uniq -
                    Host.in_holiday(date).pluck('hosts.id').uniq -
                    Host.has_booking(date).pluck('hosts.id').uniq

      # host_in = " AND id IN(#{free_hosts.join(',')})"
      host_in = " AND hosts.id IN(#{free_hosts.join(',')})"
    end

    # Host.where( age + loc + group + host_in )
    #     .where(approved:true).where("experiences_count > 0").order('random()')
    # removed random here
    Host.joins(:experiences).where(age + loc + host_in + group).uniq
  end

  def self.search_by( params = {} )
    unlist = []
    unlist << :id if params[:date].blank?
    unlist << :dob if params[:age_range] == "Age"
    unlist << :state if params[:location] == "Location"
    unlist << :max_group_size if params[:max_group] == "Guests"

    unless params[:date].blank?
      host_list = Host.in_holiday(params[:date]).pluck('hosts.id') +
                  Host.has_booking(params[:date]).pluck('hosts.id')
    end

    date_ranges = Host.age_ranges.zip(Host.dob_ranges).to_h[params[:age_range]]

    Host.where(dob: date_ranges) #filter age_range
        .where(state: params[:location])
        .where("max_group_size >= ?", params[:max_group].to_i)
        .where.not(id: host_list.to_a.uniq) #filter out unavailable dates
        .unscope(where: unlist) #unscoping array
        .where(approved:true).where("experiences_count > 0").order('random()')
  end

  def self.refresh_max_group_size
    Host.all.find_each do |host|
      max_size = host.experiences.normal_events.maximum(:max_group_size)
      host.update(max_group_size: max_size)
      puts "Host ##{host.id}: max_group_size:#{host.max_group_size}"
    end
  end

  def age
    # now = Time.now.utc.to_date
    # dob = self.dob
    # return nil if dob.nil?
    # now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    Date.today.year - dob.year unless dob.nil?
  end

  def free?(date)
    !(self.holidays.find_by(date:date) || self.bookings.find_by(date:date, status:'confirmed'))
  end

  # def max_group_size
  #   self.experiences.maximum(:max_group_size)
  # end

  def self.get_location
  	# ["Region","Zeeland", "Nordjylland", "Midtjylland","Syddanmark", "Hovedstaden"]
		[['Location','Location'],
		 ['Zealand','Zeeland'],
		 ['North Jutland', 'Nordjylland'],
		 ['Mid Jutland', 'Midtjylland'],
		 ['South Jutland & Fyn', 'Syddanmark'],
		 ['Greater Copenhagen', 'Hovedstaden']]
	end

  def location
    hash = {'Zeeland' => 'Zealand',
    'Nordjylland' => 'North Jutland',
    'Midtjylland' => 'Mid Jutland',
    'Syddanmark' => 'South Jutland & Fyn',
    'Hovedstaden' => 'Greater Copenhagen'}

    x = [self.suburb, hash[self.state], self.country].reject do |itm|
      itm.nil? || itm.empty?
     end.join(', ')
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

  def host_approved?
    self.approved
  end

  def self.reset_experiences_counter
    Host.ids.each { |id| Host.reset_counters(id, :experiences) }
  end

  def set_holiday(dates)
    self.holidays.destroy_all
    return true if dates.blank?

    dates.split(',').each do |date|
      holiday = self.holidays.new(date:date.strip)
      holiday.save
    end
    true
  end

  def all_notifications
    self.notifications.all
  end

  def next_host_party
    self.experiences.special_events.each do |event|
      if event.date > Time.now
        return event
      end
    end

    return nil

  end
end
