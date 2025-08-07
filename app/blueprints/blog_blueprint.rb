# frozen_string_literal: true

class BlogBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :content, :cover_image_url

  view :normal do
    association :user, blueprint: UserBlueprint, view: :normal
  end
end
