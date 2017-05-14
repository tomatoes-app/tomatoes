module TomatoesHelper
  def tomato_duration(tomato)
    "#{(tomato.created_at - tomato.duration.minutes).strftime('%I:%M %p')} - #{tomato.created_at.strftime('%I:%M %p')}"
  end
end
