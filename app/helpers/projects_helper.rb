module ProjectsHelper
  def money_budget(project)
    number_to_currency(project.money_budget, unit: User::CURRENCIES[project.user.currency])
  end
end
