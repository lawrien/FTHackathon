require 'rubygems'
require 'bundler'
require 'sinatra'
require File.expand_path("../lib/FTHackathon",__FILE__)

# Serve our index file by default
use Rack::Static , :urls => { "/" => "index.html" } , :root => "public"
 
# Setup Rack
run Rack::URLMap.new( {
  "/"    => Rack::Directory.new( "public" ), # Serve our static content
  "/shift" => FTHackathon::Server.new                          # Sinatra app
} )


