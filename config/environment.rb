require 'rack/cache'
Rails.application.middleware.use Rack::Cache,
   verbose: true,
   metastore: Settings.rake_cache_meta,
   entitystore: Settings.rake_cache_body

require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!