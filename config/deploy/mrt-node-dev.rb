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
set :rails_env, "mrt-node-dev"

puts "----- mrt-node-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-node-dev"

set :application, "merritt-node"
# Do not define, Capistrano will prompt at build time
set :build_url, "http://builds.cdlib.org/job/mrt-node%20(default)/lastSuccessfulBuild/artifact/node-war-uc3/node-8001-dev/mrt-node.node-8001-dev.war"
set :target, "mrt-node.war"
set :deploy_to, "/dpr2/apps/node35801"

set :tomcat_pid, "#{fetch(:deploy_to)}/node.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "replic01-aws-dev.cdlib.org", user: "dpr2", roles: %w{web app}

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
        puts "No pre-stop Node action"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "No post-start Node action"
    end
  end
end
