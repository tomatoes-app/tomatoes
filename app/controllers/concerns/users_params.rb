module UsersParams
  def resource_params
    params.require(:user).try(
      :permit,
      :name,
      :email,
      :image,
      :time_zone,
      :color,
      :work_hours_per_day,
      :average_hourly_rate,
      :currency,
      :volume,
      :ticking
    )
  end
end
