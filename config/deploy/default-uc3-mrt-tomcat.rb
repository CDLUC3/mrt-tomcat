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
set :build_url   ,     ENV['ARTIFACT_URL']             || 'undefined'
set :target,           ENV['ARTIFACT_TARGET']          || 'undefined'

set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:service)}"
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
