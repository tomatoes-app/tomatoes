module RankingsHelper
  def ranking_title(time_period)
    case time_period
    when 'all_time'
      'All time top tomatoers'
    when 'today'
      "Today's top tomatoers"
    when 'this_week'
      "This week's top tomatoers"
    when 'this_month'
      "This month's top tomatoers"
    end
  end
end
