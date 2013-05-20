require 'json'
require 'sinatra/base'

module FTHackathon
  class Server < Sinatra::Base
    enable :dump_errors
    start = Time.now.to_f

    # global before filter
    before /.*/ do
      content_type :json
    end

    get "/" do
      {:results => "Hello world!"}.to_json
    end

    post "/share" do
      data = JSON.parse(request.body.read)
      id = Mongo.upsert("shared",data)
      id.to_s
      # params.to_json
    end

    get "/:id"  do 
      params[:id]
    end
  end
end
