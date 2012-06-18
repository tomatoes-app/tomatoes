module ApplicationHelper
  def relative_day(date)
    case date.to_date
    when Date.current
      "Today"
    when Date.yesterday
      "Yesterday"
    else
      date.strftime("%A, %B %e")
    end
  end
  
  def humanize(secs)
    [[60, "second"], [60, "minute"], [24, "hour"], [365, "day"], [1000, "year"]].map do |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        pluralize(n.to_i, name) if n.to_i > 0
      end
    end.compact.reverse.join(', ')
  end

  def content_for_user(user, &block)
    if current_user && current_user.id == user.id
      capture(&block)
    end
  end
end
