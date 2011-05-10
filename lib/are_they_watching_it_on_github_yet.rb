require 'sinatra/base'
require 'octokit'

class AreTheyWatchingItOnGithubYet < Sinatra::Base
  set :public, "public"

  get '/' do
    haml :home
  end

  get '/check' do
    @what  = params['what']
    redirect '/' if !@what or @what == ''

    who    = params['who']
    @repo  = !!@what.match('/')
    method = @repo ? :watchers : :followers

    begin
      watchers   = Octokit.send(method, @what)
      candidates = who.split(',').collect(&:strip)
      @found     = candidates.select { |username| watchers.include?(username) }
      @missing   = candidates.select { |username| !watchers.include?(username) }
      haml :results
    rescue Octokit::NotFound
      haml :notfound
    rescue
      haml :error
    end

  end

end
