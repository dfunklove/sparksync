class Dateview < ApplicationRecord
  attr_accessor :s_date_formatted, :e_date_formatted
  attr_reader :bad_start, :bad_end

  DATE_FORMAT = "%m-%d-%Y".freeze
  #PATTERN = /\d\d\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/
  SPATTERN = /\A(1[012]|0{0,1}[1-9])[-\/](3[01]|[12][0-9]|0{0,1}[1-9])[-\/]((20)?\d\d)\z/
  PATTERN = /\A(\d{1,2})[-\/](\d{1,2})[-\/](\d{2,4})\z/
  CENTURY = /\A(20)?\d\d\z/
  MONTH = /\A(1[012]|0{0,1}[1-9])\z/
  TWODIGITS = /\d\d/

  # these are doing nothing
  validates :s_date_formatted, presence: true, format: {with: SPATTERN }
  validates :e_date_formatted, presence: true, format: { with: SPATTERN }

  def initialize
    super
    self.start_date = (DateTime.now - 7.days).beginning_of_day
    self.end_date = DateTime.now.end_of_day
  end

  def date_errs(valarray, errs)
    bad = nil
    puts "valarray[0] " + valarray[0] + " errs[0] " + errs[0].to_s + "$"
    if !((date, month, day, year = PATTERN.match(valarray[0]).to_a.flatten).empty?)
      puts "date " + date + " year " + year + " month " + month + " day " + day
      y = year.to_i
      if !(CENTURY.match?(year))
        errs << "'YYYY' must be year in 21st century"
        bad = valarray[0]
      elsif( y < 100 )
        puts "appending prefix '20' to year"
        year = "20" + year # assume year is 20-something if user omitted
      end
      if MONTH.match?(month)
        # assume January, March, May, July, August, October, December
        max = 31
        if (m = month.to_i) == 2 # if February
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
          if !TWODIGITS.match?(month)
            month = "0" + month
          end
          if !TWODIGITS.match?(day)
            day = "0" + day
          end
          valarray[0] = month + "-" + day + "-" + year
          puts valarray[0]
          return bad # no errors unless wrong century
        else
          errs << "'DD' must be in range 0-#{max} for #{Date::ABBR_MONTHNAMES[m]} #{year}"
        end
      else # can't get the month right don't bother checking day
        errs << "'MM' must be in range 01-12"
      end
    end
    return valarray[0] # if there were no errors it would have returned already
  end

  # override the writer and reader functions provided by attr_accessor
  def s_date_formatted=(value)
    if value.nil? or value.blank?
      puts "start date blank"
      errors.add(:start_date, "Can't be blank")
      return 
    end
    errs = []
    valarray = [value]
    if @bad_start = date_errs(valarray, errs)
      puts "bad_start " + @bad_start
      errors.add(:base, "Please format date 'MM-DD-YYYY'")
      errs.each do |e|
        puts "err " + e
        errors.add(:start_date, e)
      end
    else
      value = valarray[0]
      puts "no errors found updating start_date " + value
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
    valarray = [value]
    if @bad_end = date_errs(valarray, errs)
      puts "bad_end " + @bad_end
      if !@bad_start
        errors.add(:base, "Please format date 'MM-DD-YYYY'")
      end
      errs.each do |e|
        puts "err " + e
        errors.add(:end_date, e)
      end
    end
    # assume start_date is set before end_date
    if !@bad_end  
      value = valarray[0]
      puts "no errors found updating end_date " + value
      poss_date = DateTime.strptime(value, DATE_FORMAT).to_date.end_of_day
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
