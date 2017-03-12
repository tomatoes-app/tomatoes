require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'must have a name' do
    project = Project.new

    assert_not project.valid?
    assert_includes project.errors.messages[:name], 'can\'t be blank'
  end

  test 'is valid if it has a name' do
    project = Project.new(name: 'test')

    assert project.valid?
  end

  test 'money_budget, if set, must be a number' do
    project = Project.new(money_budget: 'test')

    assert_not project.valid?
    assert_includes project.errors.messages[:money_budget], 'is not a number'
  end

  test 'money_budget, if set, must be a number greater than zero' do
    project = Project.new(money_budget: -1)

    assert_not project.valid?
    assert_includes project.errors.messages[:money_budget], 'must be greater than 0'
  end

  test 'time_budget, if set, must be a number' do
    project = Project.new(time_budget: 'test')

    assert_not project.valid?
    assert_includes project.errors.messages[:time_budget], 'is not a number'
  end

  test 'time_budget, if set, must be a number greater than zero' do
    project = Project.new(time_budget: -1)

    assert_not project.valid?
    assert_includes project.errors.messages[:time_budget], 'must be greater than 0'
  end
end
