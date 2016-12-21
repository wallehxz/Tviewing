# This file is used by Rack-based servers to start the application.
# require 'rack/cache'

# use Rack::Cache,
#   :verbose     => true,
#   :metastore   => Settings.rake_cache_meta,
#   :entitystore => Settings.rake_cache_body

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
