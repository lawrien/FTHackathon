require 'json'
require 'sinatra/base'
require 'bson'
require 'rest-client'
require 'nokogiri'

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
      p data
      id = Mongo.upsert(FTHackathon::DataStore,data)
      response.header['Location'] = "/shift/shared/#{id.to_s}"
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
        404
      else
        # Parse into JSON
        shared = docs[0]
        # fetch from API
        url = "http://api.ft.com/content/items/v1/#{shared['articleId']}"
        resp = RestClient.get url, :params => {:apiKey => '74ceebd2d62ad1e882862db317e2fb95', :aspects => 'body,summary,title,editorial' }
        # body = JSON.parse(resp.body)
        puts "Called #{url}"
        puts "Got #{JSON.pretty_generate(JSON.parse(resp.to_s))}"

        attr = JSON.parse(resp.to_s)

        # get html content
        doc = Nokogiri::HTML(attr['item']['body']['body'])

        # extract the paragraphs we need
        paras = shared['paras'].map{|entry| doc.css("p[#{entry}]").to_html  }

        # wrap them in divs for ease of styling
        output = paras.map{|content| 
          "<div>#{content}</div>"
        }.join("\n")

        rendered_response=<<-EOS
<!DOCTYPE html>
<html lang="en">
<head>
<title>#{attr['item']['title']['title']}</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="#{attr['item']['summary']['excerpt']}" />
    <meta name="author" content="#{attr['item']['editorial']['byline']}" />
    <style>
      html {
        background-color: #fff1e0;
        color: black;
        font-family: "Helvetica", "Arial", sans-serif;
      }

      h1 {
        margin: 25px 10px;
        font-size: 20px;
        font-weight: bold;
      }

      p {
        margin: 10px;
        font-size: 18px;
      }

      p:last-child {
        color: #888;
        font-size: 16px;
      }
    </style>
</head>
<body data-spy="scroll" data-target=".subnav" data-offset="50">
      <div class="suHeaderLeftImage">
        <a href="http://www.ft.com">
          <img id="logbco" width="138" height="70" alt="Financial Times" src="http://www.ft.com/Common/Subscription/images/ftlogo2.gif"></img>
        </a>
      </div>

      <h1>#{attr['item']['title']['title']}</h1>

      #{ output }

      <p>
        <a href="http://www.ft.com/cms/s/0/#{shared['articleId']}"> Read the full article at FT.com</a>
      </p>
</body>
</html>
EOS
        rendered_response
      end
    end
  end
end

__END__
Expected format of incoming query POST /shift/share
  {articleId: "xyz", paras: [1,2,3] } -> mongo id (200)

Expected format of incoming query GET /shift/shared/:id
  return stored json from POST /shift/share or 404 on error
