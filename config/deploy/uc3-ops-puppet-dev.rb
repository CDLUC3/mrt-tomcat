#set :application, "merritt-audit"
set :rails_env,        ENV['RAILS_ENVIRONMENT']       || 'uc3-ops-puppet-dev'
set :cap_repo_url,     ENV['CAP_REPO_URL']            || 'https://github.com/cdluc3/mrt-tomcat.git'
set :cap_repo_branch,  ENV['CAP_REPO_BRANCH']         || 'main'
set :user,             ENV['USER']                    || 'dpr2'
set :group,            ENV['GROUP']                   || 'dpr2'
set :home_dir,         ENV['HOME']                    || '/apps/dpr2'
set :service,          ENV['MERRITT_SERVICE']         || 'audit'
set :semantic_version, ENV['MERRITT_SERVICE_RELEASE'] || 'undefined'
set :artifact_server,  ENV['ARTIFACT_SERVER'],        || 'http://builds.cdlib.org'
set :artifact_path,    ENV['ARTIFACT_PATH'],          || '/userContent/mrt-audit'
set :artifact_name,    ENV['ARTIFACT_NAME'],          || "mrt-audit-#{fetch(:semantic_version)}.war"

set :target, "#{fetch(:artifact_name)}"
set :build_url, "#{fetch(:artifact_server)}#{fetch(:artifact_path)}/#{fetch(:artifact_name)}"
#set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
#set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"
set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:service)}"
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
