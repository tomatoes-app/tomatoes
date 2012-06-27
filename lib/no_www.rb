# Websites should have a canonical address. This address shouldn’t begin with “www” because 
# it’s unnecessary and wasteful. See http://no-www.org/ for details. This middleware catches 
# requests that begin with “www” and redirects them to the more reasonable non-www address.

class NoWww
  STARTS_WITH_WWW = /^www\./i
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env['HTTP_HOST'] =~ STARTS_WITH_WWW
      [301, { 'Location' => Rack::Request.new(env).url.sub(/www\./i, '') }, ['Redirecting...']]
    else
      @app.call(env)
    end
  end
  
end