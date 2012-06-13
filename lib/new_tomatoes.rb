class NewTomatoes
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    [301, { 'Location' => 'http://tomatoes2.heroku.com' }, ['Redirecting...']]
  end
  
end