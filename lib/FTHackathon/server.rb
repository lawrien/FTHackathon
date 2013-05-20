require 'json'
require 'sinatra/base'
require 'bson'

module FTHackathon
  DataStore = "shared"

  class Server < Sinatra::Base
    use Rack::Static, :urls => ["/img", "/js", "/css"], :root => "public"
    enable :dump_errors
    start = Time.now.to_f

   #  get "/" do
   #    [
   #      200,
   #      {
   #        'Content-Type'  => 'text/html',
   #        'Cache-Control' => 'public, max-age=86400'
   #      },
   #      File.open('public/aa11044c-c126-11e2-9767-00144feab7de.html', File::RDONLY)
   #    ]
   # end

  # creation of docs
   post "/share" do
      data = JSON.parse(request.body.read)
      id = Mongo.upsert(FTHackathon::DataStore,data)
      response.header['Location'] = "/#{id.to_s}"
      id.to_s
    end

    # retreival of docs
    get "/shared/:id"  do
      # Need to check we have a valid objectid :-)
      id = params[:id]
      obj_id = BSON::ObjectId(id)
      docs = Mongo.find(FTHackathon::DataStore,{"_id" => obj_id}).to_a
      if docs.size == 0
        puts "No luck"
      else
        puts docs[0]
      end
    end
  end
end
