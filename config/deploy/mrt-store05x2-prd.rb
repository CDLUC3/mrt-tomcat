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
set :rails_env, "mrt-store05x2-prd"

puts "----- mrt-store05x2-prd branch of https://github.com/CDLUC3/tomcat8_catalina_base -----"
set :repo_url, "https://github.com/CDLUC3/tomcat8_catalina_base"
set :branch, "mrt-store05x2-prd"

set :application, "merritt-store"
set :build_url,   "http://builds.cdlib.org/view/Merritt/job/mrt-store-pub/ws/store-war/war/prod/storage.war"
set :target, "storage.war"
set :deploy_to, "/dpr2store/apps/storage35121"

set :tomcat_pid, "#{fetch(:deploy_to)}/storage.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# additional directories needed by storage
set :linked_dirs, fetch(:linked_dirs).push("webapps/container")

server "uc3-mrtstore05x2-prd.cdlib.org", user: "dpr2store", roles: %w{web app}

# custom
namespace :custom do

  desc 'Custom deploy action'
  task :deploy_bits do
    on roles(:app) do
        puts "Add source code version to Tomcat directory"
        execute "/usr/bin/curl --silent -X GET https://api.github.com/repos/cdluc3/mrt-store/commits | /bin/fgrep 'sha' | /usr/bin/head -1 >> /dpr2store/apps/storage35121/version"
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
