class Teacher < User
    has_many :lessons, dependent: :nullify, foreign_key: 'user_id'
    has_many :group_lessons, dependent: :nullify, foreign_key: 'user_id'
    has_many :logins, foreign_key: 'user_id'
  default_scope -> { order(last_name: :asc) }

    def last_login
        self.logins.order(time_in: :desc).first
    end

    def lessons_in_progress
        self.lessons.where(time_out: nil).where(group_lesson_id: nil)
    end

    def group_lessons_in_progress
        self.group_lessons.where(time_out: nil)
    end
    
    # Singleton methods

    def self.all_in_lessons
        self.joins(:lessons).where('lessons."time_out" is null').distinct
    end

    # Return all teachers who logged in today and are currently logged in 
    def self.all_logged_in_today
        self.joins(:logins).where('logins.time_out is null AND logins.time_in > ?', Time.new.beginning_of_day).distinct
    end

    def self.compute_hours(collection)
        tot_hours = 0
        collection.each do |thing|
            tot_hours += thing[:time_out] - thing[:time_in]
        end
        # convert seconds to hours
        tot_hours/3600
    end

    def self.waiting_for_students
        all_logged_in_today - all_in_lessons
    end
end
