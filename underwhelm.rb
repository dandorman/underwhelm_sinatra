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
    tweet = Twitter.user_timeline("dandorman").find {|tweet| tweet.text !~ /^@/}
    File.open(tweet_file, 'w') {|f| f.write(tweet.to_json) }
    haml :tweet, :locals => { :tweet => tweet }
  end

  get '/' do
    if File.readable?(tweet_file)
      @tweet = Hashie::Mash.new(JSON.parse(File.open(tweet_file).read))
    else
      @tweet = nil
    end
    haml :index
  end

  def tweet_file
    @tweet_file ||= File.dirname(__FILE__) + "/tmp/tweet"
  end

end
