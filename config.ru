require 'rubygems'
require 'bundler'
require 'sinatra'
require File.expand_path("../lib/FTHackathon",__FILE__)

run FTHackathon::Server
