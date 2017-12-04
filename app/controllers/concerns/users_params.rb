module UsersParams
  def resource_params
    params.permit(
      user: %i[
        name
        email
        image
        time_zone
        color
        work_hours_per_day
        average_hourly_rate
        currency
        volume
        ticking
      ]
    ).require(:user)
  end
end
