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
set :rails_env, "mrt-storeAudit03-prd"

puts "----- mrt-storeAudit03-prd branch of https://github.com/CDLUC3/tomcat8_catalina_base -----"
set :repo_url, "https://github.com/CDLUC3/tomcat8_catalina_base"
set :branch, "mrt-storeAudit03-prd"

set :application, "merritt-storeAudit"
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-storeCloud%20(default)/ws/store-war/vm-read/storage.vm-read.war"

set :target, "storage.war"
set :deploy_to, "/dpr2/apps/storage35122"

set :tomcat_pid, "#{fetch(:deploy_to)}/storage.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "audit03-aws.cdlib.org", user: "dpr2", roles: %w{web app}

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
        puts "No custom prestop action"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "No custom poststart action"
    end
  end
end
