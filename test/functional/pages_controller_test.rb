require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def setup
    @controller = HighVoltage::PagesController.new
  end

  test 'should get how_to' do
    get :show, params: { id: 'how_to' }
    assert_response :success
  end
end
