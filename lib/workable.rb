module Workable
  TOMATO_TIME_FACTOR   = (Tomato::DURATION*4 + Tomato::BREAK_DURATION*(3+3))/(Tomato::DURATION*4).to_f
  HOURS_PER_DAY_FACTOR = 24/8.0
  DAYS_PER_WEEK_FACTOR = 7/5.0
  WORK_TIME_FACTOR     = DAYS_PER_WEEK_FACTOR * HOURS_PER_DAY_FACTOR * TOMATO_TIME_FACTOR

  def work_time
    tomatoes.count * Tomato::DURATION
  end

  def effective_work_time
    (work_time * WORK_TIME_FACTOR).to_i
  end
end