# frozen_string_literal: true

class BlogBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :content, :cover_image_url

  view :normal do
    field :liked do |blog, options|
      blog.liked?(options[:current_user])
    end

    field :likes_count do |blog|
      blog.likes.count
    end

    association :user, blueprint: UserBlueprint, view: :normal
  end
end
