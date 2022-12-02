require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/post_repository"
require_relative "lib/user_repository"
require_relative "lib/database_connection"
require "sequel"

DatabaseConnection.connect("Chitter")

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get "/main" do
    post_repo = PostRepository.new()
    @posts = post_repo.all_with_poster
    return erb(:main)
  end

  get "/" do
    post_repo = PostRepository.new()
    @posts = post_repo.all_with_poster
    return erb(:main)
  end

  get "/login" do
    return erb(:login)
  end

  post "/login" do
    username = params[:username]
    pass = params[:pass]
    user_repo = UserRepository.new
    user = user_repo.find_by_username(username)
    if user == nil
      return erb(:error)
    elsif user.pass = pass
      session[:user_id] = user.id
      p session[:user_id]
      return erb(:login_success)
    else
      return erb(:error)
    end
  end

  get "/post" do
    if session[:user_id] == nil
      return erb(:login)
    else
      return erb(:post)
    end
  end

  post "/post" do
    post_repo = PostRepository.new()
    new_post = Post.new()
    new_post.content = params[:content]
    new_post.post_time = DateTime.now()
    new_post.poster_id = session[:user_id]
    post_repo.create(new_post)
    @posts = post_repo.all_with_poster
    return erb(:main)
  end

  get "/logout" do
    session[:user_id] = nil 
    return erb(:logout)
  end
end
