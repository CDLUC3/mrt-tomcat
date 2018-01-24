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
set :rails_env, "mrt-replic02-prd"

puts "----- mrt-replic02-prd branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-replic02-prd"

set :application, "merritt-replic"
# Do not define, Capistrano will prompt at build time
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-build-replic/ws/replication-war/war/prod/mrtreplic.war"
set :target, "mrtreplic.war"
set :deploy_to, "/dpr2/apps/replic38001"

set :tomcat_pid, "#{fetch(:deploy_to)}/replic.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# additional directories needed by storage
set :linked_dirs, fetch(:linked_dirs).push("curl")

server "replic02-aws.cdlib.org", user: "dpr2", roles: %w{web app}

# custom
namespace :custom do

  desc 'Custom deploy action'
  task :deploy_bits do
    on roles(:app) do
        puts "Add source code version to Tomcat directory"
        execute "/usr/bin/curl --silent -X GET  https://api.github.com/repos/cdluc3/mrt-replic/commits | /bin/fgrep 'sha' | /usr/bin/head -1 >> /dpr2/apps/replic38001/version"
    end
  end

  desc 'Custom pre-stop action'
  task :prestop do
    on roles(:app) do
        puts "Shutdown Replication Application"
        execute "/usr/bin/curl --max-time 1800 --silent -X POST http://localhost:38001/mrtreplic/service/shutdown?t=xml"
        execute "sleep 60"
    end
  end

  desc 'Custom post-start action'
  task :poststart do
    on roles(:app) do
        puts "Startup Replication Application"
        execute "sleep 60"
        execute "/usr/bin/curl --max-time 1800 --silent -X POST http://localhost:38001/mrtreplic/service/start?t=xml"
    end
  end
end
