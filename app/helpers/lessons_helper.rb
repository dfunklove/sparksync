module LessonsHelper
  def self.add_empty_ratings(lesson)
    while lesson.ratings.length < Goal::MAX_PER_STUDENT
      x = Rating.new
      x.goal = Goal.new
      lesson.ratings << x
    end  
  end

  def self.default_start_date
    return Date.today - 6.days
  end

  def self.default_end_date
    return Date.today + 1.day
  end
end
