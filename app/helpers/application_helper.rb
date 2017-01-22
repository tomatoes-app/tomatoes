module ApplicationHelper
  def humanize(secs)
    [[60, 'second'], [60, 'minute'], [24, 'hour'], [365, 'day'], [1000, 'year']].map do |count, name|
      if secs.positive?
        secs, n = secs.divmod(count)
        pluralize(n.to_i, name) if n.to_i.positive?
      end
    end.compact.reverse.join(', ')
  end

  def content_for_user(user, &block)
    capture(&block) if current_user && current_user.id == user.id
  end

  def money(number, unit)
    number_to_currency(number, unit: unit, format: '%u %n', precision: 0)
  end

  def hourly_rate(number, unit)
    number = number_with_precision(number, precision: 2, delimiter: ',')
    "#{number} #{unit}/hour"
  end

  def flash_class(key)
    case key.to_sym
    when :notice
      'alert-success'
    when :alert
      'alert-danger'
    else
      'alert-info'
    end
  end
end
