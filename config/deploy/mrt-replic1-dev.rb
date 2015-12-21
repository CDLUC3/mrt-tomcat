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
set :rails_env, "mrt-replic-dev"

puts "----- mrt-replic-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-replic-dev"

set :application, "merritt-replic"
# Do not define, Capistrano will prompt at build time
set :build_url, "http://builds.cdlib.org/job/mrt-replication/lastSuccessfulBuild/artifact/replic-war/vm-dev/mrtreplic.vm-dev.war"
set :target, "mrtreplic.war"
set :deploy_to, "/dpr2/apps/replic38001"

set :tomcat_pid, "#{fetch(:deploy_to)}/replic.pid"
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
        puts "Shutdown Replication Application"
        execute "/usr/bin/curl --max-time 1800 --silent -X POST http://localhost:38001/mrtreplic/service/shutdown?t=xml"
        execute "sleep 30"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Replication Application"
        execute "sleep 30"
        execute "/usr/bin/curl --max-time 1800 --silent -X POST http://localhost:38001/mrtreplic/service/start?t=xml"
    end
  end
end
