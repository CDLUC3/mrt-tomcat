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
set :rails_env, "mrt-audit03-prd"

puts "----- mrt-audit03-prd branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-audit03-prd"

set :application, "merritt-audit"
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-audit-default/ws/audit-war/vm-prod/mrtaudit.vm-prod.war"

set :target, "mrtaudit.war"
set :deploy_to, "/dpr2/apps/audit37001"

set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "uc3-mrtaudit3-prd", user: "dpr2", roles: %w{web app}

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
        puts "No custom deploy_bits action"
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
