# Redirect requests to heroku app domain to tomato.es

class NoHeroku
  HEROKU_DOMAIN = /tomatoes2\.herokuapp\.com/i
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env['HTTP_HOST'] =~ HEROKU_DOMAIN
      [301, { 'Location' => Rack::Request.new(env).url.sub(HEROKU_DOMAIN, 'tomato.es') }, ['Redirecting...']]
    else
      @app.call(env)
    end
  end
  
end