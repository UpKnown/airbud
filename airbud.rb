require './noko'
require 'bundler'
Bundler.require

get '/profile' do
  content_type :json
  Noko.new(params[:url]).formatted.to_json
end
