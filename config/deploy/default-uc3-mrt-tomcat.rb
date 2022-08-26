# Default mrt-uc3-tomcat deployement config.
#
set :rails_env,        ENV['RAILS_ENVIRONMENT']        || 'undefined'
set :repo_url,         ENV['CAP_REPO_URL']             || 'https://github.com/cdluc3/mrt-tomcat.git'
set :branch,           ENV['CAP_REPO_BRANCH']          || 'main'
set :user,             ENV['USER']
set :group,            ENV['GROUP']
set :home_dir,         ENV['HOME']                     || "/apps/#{fetch(:user)}"
set :service,          ENV['MERRITT_SERVICE']          || 'undefined'
set :semantic_version, ENV['MERRITT_SERVICE_RELEASE']  || 'undefined'
set :artifact_url,     ENV['ARTIFACT_URL']             || 'undefined'
set :artifact_name,    ENV['ARTIFACT_NAME']            || 'undefined'

set :target, "#{fetch(:artifact_name)}"
set :build_url, "#{fetch(:artifact_url)}"
set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:service)}"
set :timestamp, -> { `/usr/bin/date +"%Y%m%d-%H.%M.%S"`.chomp }
server "localhost", user: "#{fetch(:user)}", roles: %w{app}

# hook to capture subservice specific tasks
#
namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
      puts "Nothing to do"
    end
  end
end
