require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

  describe "GET #avatar" do
    it "returns http success" do
      get :avatar
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #info" do
    it "returns http success" do
      get :info
      expect(response).to have_http_status(:success)
    end
  end

end
