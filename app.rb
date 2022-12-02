require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/post_repository"
require_relative "lib/user_repository"
require_relative "lib/database_connection"

DatabaseConnection.connect

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

  get "/signup" do
    return erb(:signup)
  end

  post "/signup" do
    user_repo = UserRepository.new()
    new_user = User.new()
    new_user.username = params[:username]
    new_user.pass = params[:pass]
    new_user.first_name = params[:first_name]
    new_user.last_name = params[:last_name]
    user_repo.create(new_user)
    post_repo = PostRepository.new()
    @posts = post_repo.all_with_poster
    found_user = user_repo.find_by_username(new_user.username)
    session[:user_id] = found_user.id
    return erb(:main)
  end
end
