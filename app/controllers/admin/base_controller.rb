class Admin::BaseController < ApplicationController
  layout 'admin'
  load_and_authorize_resource
  force_ssl if Rails.env.production?

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
