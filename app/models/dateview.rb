class Dateview < ApplicationRecord
  attr_accessor :s_date_formatted, :e_date_formatted
  attr_reader :bad_start, :bad_end

  DATE_FORMAT = "%Y-%m-%d".freeze
  #PATTERN = /\d\d\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/
  PATTERN = /(\d\d\d\d)-(\d\d)-(\d\d)/
  CENTURY = /(^20)/
  MONTH = /(0[1-9]|1[012])/
  # these are doing nothing
  validates :s_date_formatted, presence: true, format: { with: /(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/ }
  validates :e_date_formatted, presence: true, format: { with: /(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/ }

#  validate do
#    self.errors[:s_date_formatted] << "Please format date 'YYYY-MM-DD" unless (DateTime.parse(self.s_date_formatted) rescue false)
#    self.errors[:e_date_formatted] << "Please format date 'YYYY-MM-DD" unless (DateTime.parse(self.e_date_formatted) rescue false)
#  end
#
  # this only runs for setting the variables stored in database how do i change that?
  # could check in s_date_formatted or e_date_formatted, but which get set first?
  # also should probably check for correct days of month depending on year and month
  # been done before that is the beauty of reuse
  # why is everything i found pure shit?
#  validate :start_b4_end

#  def start_b4_end
#    puts "validating start_date or end_date "
#    errors.add(:base, "Start Date must be before End Date") if start_date > end_date
#  end

  def date_errs(value, errs)
    bad = nil
    if !((date, year, month, day = PATTERN.match(value).to_a.flatten).empty?)
      puts "date " + date + " year " + year + " month " + month + " day " + day
      if !(CENTURY.match?(year))
        errs << "'YYYY' must be year in 21st century"
        bad = value
      end
      if MONTH.match?(month)
        # assume January, March, May, July, August, October, December
        max = 31
        if (m = month.to_i) == 2 # if February
          y = year.to_i
          isleap = (y % 4 == 0) && !( (y % 100 == 0) && !(y % 400 == 0) )
          max = if isleap then 29 else 28 end
        else
          evens = [9, 4, 6, 11] # September, April, June, and November.
          evens.each do |i|
            max = 30 if i == m
          end
        end   
        d = day.to_i
        if 0 < d && d <= max 
          return bad # no errors unless wrong century
        else
          errs << "'DD' must be in range 0-#{max} for #{Date::ABBR_MONTHNAMES[m]} #{year}"
        end
      else # can't get the month right don't bother checking day
        errs << "'MM' must be in range 01-12"
      end
    end
    return value # if there were no errors it would have returned already
  end

  # override the writer and reader functions provided by attr_accessor
  def s_date_formatted=(value)
    if value.nil? or value.blank?
      puts "start date blank"
      errors.add(:start_date, "Can't be blank")
      return 
    end
    errs = []
    if @bad_start = date_errs(value, errs)
      puts "bad_start " + @bad_start
      errors.add(:base, "Please format date 'YYYY-MM-DD'")
      errs.each do |e|
        errors.add(:start_date, e)
      end
    else
      puts "no errors found updating start_date"
      self.start_date = DateTime.strptime(value, DATE_FORMAT).to_date
      puts "start date is now " + self.start_date.to_s
    end
  end

  def e_date_formatted=(value)
    if value.nil? or value.blank?
      puts "end date blank"
      errors.add(:end_date, "Can't be blank")
      return 
    end
    errs = []
    if @bad_end = date_errs(value, errs)
      puts "bad_end " + @bad_end
      if !@bad_start
        errors.add(:base, "Please format date 'YYYY-MM-DD'")
      end
      errs.each do |e|
        errors.add(:end_date, e)
      end
    end
    # assume start_date is set before end_date
    if !@bad_end  
      poss_date = DateTime.strptime(value, DATE_FORMAT).to_date
      if poss_date  > self.start_date
        puts "no errors found updating end_date"
        self.end_date = poss_date
        puts "end date is now " + self.end_date.to_s
      else
        puts "start date " + self.start_date.to_s + " is after " + value
        errors.add(:base, "Start Date must be before End Date")
        @bad_end = value
        @bad_start ||= self.s_date_formatted
      end
    end
  end

  def s_date_formatted
    self.start_date.strftime DATE_FORMAT unless self.start_date.nil?
  end

  def e_date_formatted
    self.end_date.strftime DATE_FORMAT unless self.end_date.nil?
  end

end
