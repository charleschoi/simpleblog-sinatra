# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:///blog.db"

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true
end

get "/" do
  @posts = Post.all
  erb :"posts/index"
end

get "/posts/new" do
  @title = "New post"
  @post = Post.new
  erb :"posts/new"
end

post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}"
  else
    erb :"posts/new"
  end
end

get "/posts/:id" do
  @post = Post.where(id: params[:id]).first
  @title = @post.title
  erb :"posts/show"
end

get "/posts/:id/edit" do
  @post = Post.where(id: params[:id]).first
  @title = "Edit Form"
  erb :"posts/edit"
end

put "/post/:id" do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    redirect "/posts/@{@post.id}"
  else
    erb :"posts/edit"
  end
end

delete "/posts/:id" do
  @post = Post.find(params[:id]).destory
  redirect "/"
end

get "/about" do
  @title = "About Me"
  erb :"pages/about"
end

helpers do
  def title
    if @title
      "#{@title} -- My Simple Blog"
    else
      "My Simple Blog"
    end
  end

  def pretty_date(time)
    time.strftime("%Y %b %d")
  end

  def post_show_page?
    request.path_info =~ /\/posts\/\d+$/
  end

  def delete_post_button(post_id)
    erb :_delete_post_button, locals: { post_id: post_id}
  end
end
