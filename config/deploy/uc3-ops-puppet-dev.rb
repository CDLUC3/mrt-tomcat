#set :application, "merritt-audit"
set :rails_env,        ENV['RAILS_ENVIRONMENT']        || 'undefined'
set :repo_url,         ENV['CAP_REPO_URL']             || 'https://github.com/cdluc3/mrt-tomcat.git'
set :branch,           ENV['CAP_REPO_BRANCH']          || 'main'
set :user,             ENV['USER']                     || 'undefined'
set :group,            ENV['GROUP']                    || 'undefined'
set :home_dir,         ENV['HOME']                     || "/apps/#{fetch(:user)}"
set :service,          ENV['MERRITT_SERVICE']          || 'undefined'
set :semantic_version, ENV['MERRITT_SERVICE_RELEASE']  || 'undefined'
set :artifact_url,     ENV['ARTIFACT_URL']             || 'undefined'
set :artifact_name,    ENV['ARTIFACT_NAME']            || "#{fetch(:service)}-#{fetch(:semantic_version)}.war"

set :target, "#{fetch(:artifact_name)}"
set :build_url, "#{fetch(:artifact_url)}"
set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:service)}"
#set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
#set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"
server "localhost", user: "#{fetch(:user)}", roles: %w{web app}

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
      puts "Add source code version to Tomcat directory"
      execute "/usr/bin/echo #{fetch(:semantic_version)} >> #{fetch(:deploy_to)}/version"
    end
  end

end
