module ApplicationHelper
  def relative_day(date)
    case date.to_date
    when Date.today
      "Today"
    when Date.yesterday
      "Yesterday"
    else
      date.strftime("%A, %B %e")
    end
  end
end
