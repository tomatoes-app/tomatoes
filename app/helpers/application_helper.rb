module ApplicationHelper
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

  def money(number, unit)
    number_to_currency(number, unit: unit, format: "%u %n", precision: 0)
  end

  def hourly_rate(number, unit)
    number = number_with_precision(number, precision: 2, delimiter: ',')
    "#{number} #{unit}/hour"
  end
end
