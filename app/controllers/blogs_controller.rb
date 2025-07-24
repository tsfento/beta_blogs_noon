class BlogsController < ApplicationController
  before_action :authenticate_request, except: [ :index ]

  def index
    blogs = Blog.all

    render json: BlogBlueprint.render(blogs, view: :normal)
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

  private

  def blog_params
    params.permit(:title, :content)
  end
end
