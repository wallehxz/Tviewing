set :branch, 'master'
set :rails_env, 'production'
set :rvm_ruby_version, '2.3.2'
set :rvm_type, :user
set :deploy_to, '/var/www/videos'
set :rvm_custom_path, '/home/deploy/.rvm'
set :rvm_roles, [:app, :web]

server 'deploy@tt', user: 'deploy', port: 22, roles: %w[web app db], primary: true