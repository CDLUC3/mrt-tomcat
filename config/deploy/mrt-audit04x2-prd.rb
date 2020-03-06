# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
#role :app, %w{mark.reyes@ucop.edu}
#role :web, %w{mark.reyes@ucop.edu}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
# ---- Needed for non-rails deployment???
set :rails_env, "mrt-audit04x2-prd"

puts "----- mrt-audit04x2-prd branch of https://github.com/CDLUC3/tomcat8_catalina_base -----"
set :repo_url, "https://github.com/CDLUC3/tomcat8_catalina_base"
set :branch, "mrt-audit04x2-prd"

set :application, "merritt-audit"
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-build-audit/ws/audit-war/war/prod/mrtaudit.war"

set :target, "mrtaudit.war"
set :deploy_to, "/dpr2/apps/audit37001"

set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "uc3-mrtaudit04x2-prd", user: "dpr2", roles: %w{web app}

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
        puts "Add source code version to Tomcat directory"
        execute "/usr/bin/curl --silent -X GET https://api.github.com/repos/cdluc3/mrt-audit/commits | /bin/fgrep 'sha' | /usr/bin/head -1 >> /dpr2/apps/audit37001/version"
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
