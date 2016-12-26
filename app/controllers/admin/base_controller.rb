class Admin::BaseController < ApplicationController
  force_ssl if: :ssl_configured?
  layout 'admin'
  load_and_authorize_resource
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
