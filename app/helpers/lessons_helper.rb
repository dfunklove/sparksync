module LessonsHelper
  def self.add_empty_ratings(lesson)
    while lesson.ratings.length < Goal::MAX_PER_STUDENT
      x = Rating.new
      x.goal = Goal.new
      lesson.ratings << x
    end  
  end

  def self.default_start_date
    return Time.now.beginning_of_day - 6.days
  end

  def self.default_end_date
    return Time.now.end_of_day
  end
end
