require 'resque'
require 'resque/server'
Resque::Server.use Rack::Auth::Basic do |username, password|
  username == "statisfy.me"
  password == "YcUp2&)h^8j]67H"
end