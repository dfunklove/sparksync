module LessonsHelper
  def self.add_empty_ratings(lesson)
    while lesson.ratings.length < Goal::MAX_PER_STUDENT
      x = Rating.new
      x.goal = Goal.new
      lesson.ratings << x
    end  
  end
end
