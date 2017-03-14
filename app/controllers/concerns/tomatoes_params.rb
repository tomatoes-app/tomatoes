module TomatoesParams
  def resource_params
    params.permit(tomato: [:tag_list]).require(:tomato)
  end
end
