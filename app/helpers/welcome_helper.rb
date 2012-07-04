module WelcomeHelper
  def counter_label(time_period)
    case time_period
    when :day
      "Today"
    when :week
      "This week"
    when :month
      "This month"
    end
  end
end
