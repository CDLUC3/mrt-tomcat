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
set :rails_env, "mrt-inv01-stg"

puts "----- mrt-inv-stg branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-inv01-stg"

set :application, "merritt-inv"
# Define URL for parameter "vm-dev".  MUST build prior to deployment to ensure that URL is active
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-inv/ws/inv-war/vm-stg/mrtinv.vm-stg.war"

set :target, "mrtinv.war"
set :deploy_to, "/dpr2/apps/inv36121"

set :tomcat_pid, "#{fetch(:deploy_to)}/inv.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# server "mrt-inv-aws-stg.cdlib.org", user: "dpr2", roles: %w{web app}
server "uc3-mrtinv-stg.cdlib.org", user: "dpr2", roles: %w{web app}

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
        puts "Shutdown Inventory Application"
        execute "/usr/bin/curl --silent -X POST http://localhost:36121/mrtinv/service/stop?t=xml"
        execute "sleep 5"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Inventory Application"
        execute "sleep 5"
        execute "/usr/bin/curl --silent -X POST http://localhost:36121/mrtinv/service/start?t=xml"
    end
  end
end