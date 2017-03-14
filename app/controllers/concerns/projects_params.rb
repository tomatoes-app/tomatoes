module ProjectsParams
  def resource_params
    params.permit(
      project: [
        :name,
        :tag_list,
        :money_budget,
        :time_budget
      ]
    ).require(:project)
  end
end
