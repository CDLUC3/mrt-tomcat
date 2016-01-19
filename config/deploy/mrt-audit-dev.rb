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
set :rails_env, "mrt-audit-dev"

puts "----- mrt-audit-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-audit-dev"

set :application, "merritt-audit"
# Do not define, Capistrano will prompt at build time
set :build_url, "http://builds.cdlib.org/job/mrt-audit-default/lastSuccessfulBuild/artifact/audit-war/vm-dev/mrtaudit.vm-dev.war"
set :target, "mrtaudit.war"
set :deploy_to, "/dpr2/apps/audit37001"

set :tomcat_pid, "#{fetch(:deploy_to)}/audit.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# additional directories needed by storage
set :linked_dirs, fetch(:linked_dirs).push("curl")

server "audit-aws-dev.cdlib.org", user: "dpr2", roles: %w{web app}

# custom
namespace :custom do

  desc 'Custom deploy action'
  task :deploy_bits do
    on roles(:app) do
        puts "No custom deploy_bits actions"
    end
  end

  desc 'Custom pre-stop action'
  task :prestop do
    on roles(:app) do
        puts "Shutdown Audit Application"
        execute "/usr/bin/curl --silent -X POST http://localhost:37001/service/stop"
        execute "sleep 10"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Audit Application"
        execute "sleep 10"
        execute "/usr/bin/curl --silent -X POST http://localhost:37001/service/start"
    end
  end
end
