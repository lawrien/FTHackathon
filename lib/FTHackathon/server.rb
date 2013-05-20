require 'json'
require 'sinatra/base'
require 'bson'

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
      # Need to check we have a valid objectid :-)
      id = params[:id]
      obj_id = BSON::ObjectId(id)
      docs = Mongo.find("shared",{ "_id" => obj_id}).to_a
      if docs.size == 0
        puts "No luck"
      else
        puts docs[0]
      end
    end
  end
end
