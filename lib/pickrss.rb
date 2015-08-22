%w(
  open-uri
  nokogiri
  puma
  sinatra/activerecord
  sinatra/base
  time
  uri
).each { |lib| require lib }

%w(
  core
  rss_handler
).each { |name| require_dependency File.expand_path("../pickrss/#{name}", __FILE__) }

module PickRSS
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, PickRSS.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      "pickrss"
    end

    get '/rss/*' do
      feed_uri = params['splat'].join("/").sub(/:\//, '://')
      content_type "application/xml"
      PickRSS.pick(feed_uri)
    end
  end
end

