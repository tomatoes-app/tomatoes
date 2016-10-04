module TomatoesHelper
  def tomato_duration(tomato)
    "#{(tomato.created_at - Tomato::DURATION).strftime('%I:%M %p')} - #{tomato.created_at.strftime('%I:%M %p')}"
  end
end
