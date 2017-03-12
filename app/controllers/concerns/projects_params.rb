module ProjectsParams
  def resource_params
    params.require(:project).try(
      :permit,
      :name,
      :tag_list,
      :money_budget,
      :time_budget
    )
  end
end
