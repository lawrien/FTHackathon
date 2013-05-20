require 'json'
require 'sinatra/base'
require 'bson'
require 'rest-client'

module FTHackathon
  DataStore = "shared"
  APIKEY = "74ceebd2d62ad1e882862db317e2fb95"

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
        return 403
      end
      # Parse into JSON
      shared = docs[0]
      # fetch from API
      url = "http://api.ft.com/content/items/v1/#{shared['articleId']}.json"
      resp = RestClient.get url, :params => {:apiKey => '74ceebd2d62ad1e882862db317e2fb95', :aspects => 'body,summary,title' }
      # body = JSON.parse(resp.body)
      puts "Called #{url}"
      body.to_s
    end
  end
end
