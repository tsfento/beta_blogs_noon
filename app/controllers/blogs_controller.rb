class BlogsController < ApplicationController
  before_action :authenticate_request

  def index
    blogs = Blog.all

    render json: BlogBlueprint.render(blogs, view: :normal, current_user: @current_user)
  end

  def show
    blog = Blog.find(params[:id])

    render json: BlogBlueprint.render(blog, view: :normal)
  end

  def create
    blog = @current_user.blogs.new(blog_params)

    if blog.save
      render json: BlogBlueprint.render(blog, view: :normal), status: :created
    else
      render json: blog.errors, status: :unprocessable_entity
    end
  end

  def update
    blog = Blog.find(params[:id])
    blog.update(blog_params)

    render json: blog
  end

  def destroy
    blog = Blog.find(params[:id])
    blog.destroy

    render json: blog
  end

  def like
    blog = Blog.find(params[:blog_id])
    like = blog.likes.new(user_id: @current_user.id)
    blog_creator = blog.user

    if like.save
      Pusher.trigger(blog_creator.id, "like", {
        blog_id: blog.id,
        notification: "#{@current_user.username} has like #{blog.title}!"
      })
      head :ok
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  def unlike
    blog = Blog.find(params[:blog_id])
    like = blog.likes.find_by(user_id: @current_user.id)

    if like.destroy
      head :ok
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  private

  def blog_params
    params.permit(:title, :content, :cover_image)
  end
end
