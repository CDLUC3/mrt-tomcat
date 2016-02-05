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
set :rails_env, "mrt-oai-stg"

puts "----- mrt-oai-stg branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-oai-stg"

set :application, "merritt-oai"
set :build_url, "http://builds.cdlib.org/view/Merritt/job/mrt-oai/ws/oai-war/vm-stg/mrtoai.vm-stg.war"
set :target, "mrtoai.war"
set :deploy_to, "/dpr2/apps/oai37001"

set :tomcat_pid, "#{fetch(:deploy_to)}/oai.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "uc3-mrtoai-stg", user: "dpr2", roles: %w{web app}

# custom
set :ingestqueue, "/dpr2/ingest_home/queue"

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
        puts "No custom deploy_bits action"
      end
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
