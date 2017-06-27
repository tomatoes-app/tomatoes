module TomatoesParams
  def resource_params
    params.permit(tomato: [:tag_list, :duration]).require(:tomato)
  end
end
