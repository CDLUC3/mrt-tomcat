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
set :rails_env, "mrt-ingest-dev"

puts "----- mrt-ingest-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-ingest-dev"

set :application, "merritt-ingest"
set :build_url, "http://builds.cdlib.org/job/mrt-ingest-dev/lastSuccessfulBuild/artifact/batch-war/target/mrt-ingestwar-1.0-SNAPSHOT.war"
set :target, "ingest.war"
set :deploy_to, "/dpr2/apps/ingest33121"

set :tomcat_pid, "#{fetch(:deploy_to)}/tomcat.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "uc3-mrtingest1-dev", user: "dpr2", roles: %w{web app}

# custom
set :ingestqueue, "/dpr2/ingest_home"

namespace :custom do
  desc 'Custom action`'
  task :custom_deploy_bits do
    on roles(:app) do
      if (fetch(:ingestqueue))
        puts "Create ingestqueue link in webapps"
        execute "cd #{fetch(:deploy_to)}/current/webapps/; ln -s #{fetch(:ingestqueue)} ingestqueue;"
      end
    end
  end
end
