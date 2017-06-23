Rails.application.routes.draw do

  get 'profiles/avatar'

  get 'profiles/info'

  root 'welcome#index'

  match '/admin', to:'admin/dashboard#index',via: :get, as: :admin_root
  match '/admin/search', to:'admin/dashboard#search',via: :get, as: :admin_search
  match '/admin/users', to:'admin/dashboard#users',via: :get, as: :admin_users
  match '/admin/channel/:english', to:'admin/dashboard#channel',via: :get, as: :channel
  match '/admin/import', to:'admin/dashboard#import',via: :get, as: :import
  match '/admin/view_logs', to:'admin/dashboard#view_logs',via: :get, as: :view_logs
  match '/admin/import/data', to:'admin/columns#import_data',via: :post, as: :import_data
  match '/admin/files', to:'admin/clouds#index',via: :get, as: :admin_files
  match '/admin/files/new', to:'admin/clouds#new',via: :get, as: :new_file
  match '/admin/files/:id/edit', to:'admin/clouds#edit',via: :get, as: :edit_file
  match '/admin/files/create', to:'admin/clouds#create',via: :post, as: :create_file
  match '/admin/files/update', to:'admin/clouds#update',via: :post, as: :update_file
  match '/admin/files/:id', to:'admin/clouds#destroy',via: :get, as: :delete_file
  match '/admin/videos/:id/export', to:'admin/columns#export_videos',via: :get, as: :export_videos
  match '/admin/user/:user_id/role/:role_id', to:'admin/dashboard#role_control',via: :get, as: :set_user_role
  match '/admin/user/:user_id/reset_password', to:'admin/dashboard#reset_password',via: :get, as: :reset_password
  match '/admin/videos/:id/sync_comment', to:'admin/videos#sync_youku_comment',via: :get, as: :sync_comment

  devise_for :users

  devise_scope :user do
    get 'sign_in', to:'users/sessions#new'
    post 'sign_in', to:'users/sessions#create'
    get 'sign_up', to:'users/registrations#new'
    post 'sign_up', to:'users/registrations#create'
    get 'sign_out',to:'users/sessions#destroy'
    get 'forgot_password',to:'users/passwords#new'
    post 'forgot_password',to:'users/passwords#create'
    get 'reset_password',to:'users/passwords#edit'
    put 'reset_password',to:'users/passwords#update'
  end

  namespace :admin do
    resources :columns do
      resources :videos
    end
  end

  match '/show/(:url_code).html', to:'welcome#show',via: :get, as: :show
  match '/column/(:english).html', to:'welcome#column',via: :get, as: :column
  match '/videos/more', to:'welcome#more_index',via: :get, as: :video_more
  match '/columns/more', to:'welcome#more_column',via: :get, as: :column_more
  match '/comments/create', to:'comments#create',via: :post, as: :create_comment
  match '/comment/vote/:id', to:'comments#com_vote',via: :get, as: :vote_comment
  match '/user/info', to:'users/profiles#info',via: :get, as: :user_info
  match '/user/info/update', to:'users/profiles#update_info',via: :post, as: :update_info
  match '/user/avatar', to:'users/profiles#avatar',via: :get, as: :user_avatar
  match '/user/avatar/update', to:'users/profiles#update_avatar',via: :post, as: :update_avatar

end
