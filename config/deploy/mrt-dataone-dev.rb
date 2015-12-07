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
set :rails_env, "mrt-dataone-dev"

puts "----- mrt-dataone-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-dataone-dev"

set :application, "merritt-dataone"
set :build_url, "http://builds.cdlib.org/job/mrt-metacat-dev/lastSuccessfulBuild/artifact/dist/knb.war"
set :target, "knb.war"
set :deploy_to, "/dataone/apps/metacat33181"

set :tomcat_pid, "#{fetch(:deploy_to)}/metacat.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# Custom for "dataone" role
set :default_env, { path: "/dataone/local/bin:$PATH" }

server "dataone-aws-dev.cdlib.org", user: "dataone", roles: %w{web app}

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
        puts "No custom pre-stop actions"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "No custom post-start actions"
    end
  end
end
