require 'sinatra/base'
module FTHackathon
  class Server < Sinatra::Base
    enable :dump_errors
    start = Time.now.to_f

    get "/" do
      "Hello world!"
    end
  end
end
