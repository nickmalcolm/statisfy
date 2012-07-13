require 'resque'
require 'resque/server'

if Rails.env.production?
  uri = URI.parse ENV['REDISTOGO_URL']
  Resque.redis = Redis.new :host => uri.host, :port => uri.port, :password => uri.password
end

Resque::Server.use Rack::Auth::Basic do |username, password|
  username == "statisfy.me"
  password == "YcUp2&)h^8j]67H"
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }