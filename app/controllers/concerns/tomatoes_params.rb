module TomatoesParams
  def resource_params
    params.require(:tomato).try(:permit, :tag_list)
  end
end
