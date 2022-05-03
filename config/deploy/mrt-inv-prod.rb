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
set :rails_env, "mrt-inv-prod"

puts "----- mrt-inv-prod branch of https://github.com/CDLUC3/tomcat8_catalina_base -----"
set :repo_url, "https://github.com/CDLUC3/tomcat8_catalina_base"
set :branch, "mrt-inv-prod"

set :application, "merritt-inv"
set :semantic_version, ENV['MERRITT_INVENTORY_RELEASE'] || 'undefined'
set :build_url, "http://builds.cdlib.org/userContent/mrt-inventory/mrt-inventory-#{fetch(:semantic_version)}.war"


set :target, "mrtinv.war"
set :deploy_to, "/dpr2/apps/inv36121"

set :tomcat_pid, "#{fetch(:deploy_to)}/inv.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# server "mrt-inv-aws-prd.cdlib.org", user: "dpr2", roles: %w{web app}
server "localhost", user: "dpr2", roles: %w{web app}

# custom
namespace :custom do

  desc 'Custom deploy action'
  task :deploy_bits do
    on roles(:app) do
        puts "Add source code version to Tomcat directory"
        execute "/usr/bin/curl --silent -X GET https://api.github.com/repos/cdluc3/mrt-inventory/commits | /bin/fgrep 'sha' | /usr/bin/head -1 >> /dpr2/apps/inv36121/version"
    end
  end

  desc 'Custom pre-stop action'
  task :prestop do
    on roles(:app) do
        puts "Shutdown Inventory Application"
        execute "/usr/bin/curl --silent -X POST http://localhost:36121/mrtinv/service/stop?t=xml"
        execute "sleep 30"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Inventory Application"
        execute "sleep 30"
        execute "/usr/bin/curl --silent -X POST http://localhost:36121/mrtinv/service/start?t=xml"
    end
  end
end
