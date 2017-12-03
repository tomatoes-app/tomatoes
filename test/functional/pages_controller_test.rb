require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def setup
    @controller = HighVoltage::PagesController.new
  end

  test 'should get how_to' do
    get :show, params: { id: 'how_to' }
    assert_response :success
    assert response.body.include? '<h1>How to</h1>'
  end
end
