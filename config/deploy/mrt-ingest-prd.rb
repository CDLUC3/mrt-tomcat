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
set :rails_env, "mrt-ingest-prd"
set :semantic_version, ENV['MERRITT_INGEST_RELEASE'] || 'undefined'
puts "----- mrt-ingest-prd branch of https://github.com/CDLUC3/tomcat8_catalina_base -----"
set :repo_url, "https://github.com/CDLUC3/tomcat8_catalina_base"
set :branch, "mrt-ingest-prd"

set :application, "merritt-ingest"
set :build_url, "http://builds.cdlib.org/userContent/mrt-ingest/mrt-ingest-#{fetch(:semantic_version)}.war"
set :target, "ingest.war"
set :deploy_to, "/dpr2/apps/ingest33121"

set :tomcat_pid, "#{fetch(:deploy_to)}/ingest.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "localhost", user: "dpr2", roles: %w{web app}

# custom
# set :ingestqueue, "/dpr2/ingest_home/queue"
set :ingestqueue, "/apps/ingest-prd-zfs/ingest_home/queue"

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
      if (fetch(:ingestqueue))
        puts "Create ingestqueue link in webapps"
        execute "cd #{fetch(:deploy_to)}/current/webapps/; ln -s #{fetch(:ingestqueue)} ingestqueue;"
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
