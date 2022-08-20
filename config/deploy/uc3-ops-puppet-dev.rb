# ---- Needed for non-rails deployment???
set :rails_env, "uc3-ops-puppet-dev"
set :application, "merritt-audit"
set :repo_url,         ENV['REPO_URL']        || 'https://github.com/cdluc3/mrt-tomcat.git'
set :branch,           ENV['BRANCH']          || 'capistrano_refactor'

#set :subservice, "audit37001"
set :subservice, "audit"
#set :user, "dpr2"
set :user, "uc3adm"
#set :home_dir, "/apps/dpr2"
set :home_dir, "/apps/uc3adm"
set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:subservice)}"
set :target, "mrtaudit.war"
set :semantic_version, ENV['MERRITT_SUBSERVICE_RELEASE'] || 'undefined'
set :build_url, "http://builds.cdlib.org/userContent/mrt-audit/mrt-audit-#{fetch(:semantic_version)}.war"
set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# now using puppet to manage tomcat configs.  add tomcat conf and bin dirs to shared area.
set :linked_dirs, %w{logs temp work conf bin}


server "localhost", user: "#{fetch(:user)}", roles: %w{web app}

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
        puts "Add source code version to Tomcat directory"
        execute "/usr/bin/curl --silent -X GET https://api.github.com/repos/cdluc3/mrt-audit/commits | /bin/fgrep 'sha' | /usr/bin/head -1 >> #{fetch(:deploy_to)}/version"
        # can this simply use ':semantic_version'?
        #execute "/usr/bin/echo #{fetch(:semantic_version)} > #{fetch(:deploy_to)}/version"
    end
  end

  desc 'Custom pre-stop action'
  task :prestop do
    on roles(:app) do
        puts "Shutdown Audit Application"
        execute "/usr/bin/curl --silent -X POST http://localhost:37001/mrtaudit/service/stop?t=xml"
        execute "sleep 5"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Audit Application"
        execute "sleep 5"
        execute "/usr/bin/curl --silent -X POST http://localhost:37001/mrtaudit/service/start?t=xml"
    end
  end

end
