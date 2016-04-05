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
set :rails_env, "mrt-store01-stg"

puts "----- mrt-store01-stg branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-store01-stg"

set :application, "merritt-store"
# Do not define, Capistrano will prompt at build time
set :build_url,   "http://builds.cdlib.org/view/Merritt/job/mrt-storeCloud%20(default)/ws/store-war/vm-stg/storage.vm-stg.war"

set :target, "storage.war"
set :deploy_to, "/dpr2store/apps/storage35121"

set :tomcat_pid, "#{fetch(:deploy_to)}/storage.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# additional directories needed by storage
set :linked_dirs, fetch(:linked_dirs).push("webapps/async", "webapps/container")

# server "mrt-inv-aws-stg.cdlib.org", user: "dpr2", roles: %w{web app}
server "uc3-mrtstore-stg.cdlib.org", user: "dpr2store", roles: %w{web app}

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
