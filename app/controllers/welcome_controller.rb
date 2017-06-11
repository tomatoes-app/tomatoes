class WelcomeController < ApplicationController
  layout 'welcome'
  layout false, only: :colors

  before_action :new_tomato, if: :current_user
  before_action :daily_tomatoes, if: :current_user
  before_action :tomatoes_counters, if: :current_user
  before_action :daily_projects, if: :current_user

  def index; end

  def colors
    @colors = ['#000000']

    color1, color2, color3 = [
      '#00FFFF',
      '#FFFF00',
      '#FF00FF',
    ].shuffle

    @fluo_colors = [{ color1: color1, color2: color2, color3: color3 }]

    customink_colors = %w(
      rgb(255,255,255)
      rgb(227,228,230)
      rgb(201,201,201)
      rgb(175,175,175)
      rgb(138,138,139)
      rgb(127,127,127)
      rgb(81,82,84)
      rgb(77,77,77)
      rgb(73,73,73)
      rgb(0,0,0)
      rgb(28,32,59)
      rgb(52,45,60)
      rgb(53,48,77)
      rgb(58,72,80)
      rgb(57,83,137)
      rgb(60,92,138)
      rgb(98,108,121)
      rgb(0,125,158)
      rgb(33,144,153)
      rgb(87,144,180)
      rgb(4,141,193)
      rgb(145,176,230)
      rgb(175,205,243)
      rgb(145,206,224)
      rgb(79,35,122)
      rgb(73,74,122)
      rgb(109,107,154)
      rgb(197,143,173)
      rgb(111,33,75)
      rgb(219,4,130)
      rgb(226,116,165)
      rgb(233,114,153)
      rgb(233,198,212)
      rgb(110,23,30)
      rgb(115,31,57)
      rgb(129,30,54)
      rgb(149,36,56)
      rgb(165,77,88)
      rgb(227,8,38)
      rgb(154,67,43)
      rgb(178,95,45)
      rgb(199,114,89)
      rgb(231,110,104)
      rgb(220,88,42)
      rgb(255,121,0)
      rgb(236,145,63)
      rgb(240,169,61)
      rgb(236,212,90)
      rgb(243,211,160)
      rgb(254,237,140)
      rgb(230,245,58)
      rgb(194,238,124)
      rgb(200,238,193)
      rgb(134,182,96)
      rgb(133,163,91)
      rgb(124,164,84)
      rgb(59,166,88)
      rgb(57,128,79)
      rgb(60,96,57)
      rgb(0,117,110)
      rgb(116,116,109)
      rgb(95,106,80)
      rgb(20,55,13)
      rgb(65,56,41)
      rgb(66,50,45)
      rgb(110,95,82)
      rgb(178,160,116)
      rgb(209,200,183)
      rgb(233,227,203)
    )

    combinations = customink_colors.product(customink_colors)

    @tshirt_colors = combinations.map { |a, b| { background: a, logo_color: b } }
  end

  private

  def new_tomato
    @tomato = current_user.tomatoes.build
  end

  def daily_tomatoes
    @tomatoes ||= current_user.tomatoes.after(Time.zone.now.beginning_of_day).order_by([[:created_at, :desc]])
  end

  def tomatoes_counters
    @tomatoes_count = current_user.tomatoes_counters
  end

  def daily_projects
    @projects = daily_tomatoes.collect(&:projects).flatten.uniq
  end
end
