require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'haml'
require 'twitter'
require 'twitter-text'
require 'json'

class Underwhelm < Sinatra::Base

  include Twitter::Autolink

  set :haml, :format => :html5

  get '/underwhelm.css' do
    sass :underwhelm
  end

  get '/tweet' do
    tweet = Twitter.user_timeline("dandorman").find {|tweet| tweet.text !~ /^@/}.to_json
    File.open("/tmp/tweet", 'w') {|f| f.write(tweet) }
    haml :tweet, :locals => { :tweet => tweet }
  end

  get '/' do
    if File.readable?("/tmp/tweet")
      @tweet = JSON.parse(File.open("/tmp/tweet").read)
    end
    haml :index
  end

end
