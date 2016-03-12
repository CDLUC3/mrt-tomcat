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
set :rails_env, "mrt-feeder-prd"

puts "----- mrt-feeder-prd branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-feeder-prd"

set :application, "merritt-feeder"
set :build_url, "http://builds.cdlib.org/job/mrt-feeder%20(production)/lastSuccessfulBuild/artifact/feedermets-war/prd-coot/feeder-mets.prd-coot.war"
set :target, "feeder-mets.war"
set :deploy_to, "/dpr2/apps/feeder33140"

set :tomcat_pid, "#{fetch(:deploy_to)}/feeder.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

# additional directories needed by storage
set :linked_dirs, fetch(:linked_dirs).push("cert")


server "cdl-mrtwrk-p02", user: "dpr2", roles: %w{web app}

# custom
set :feederout, "feederout"

namespace :custom do
  desc 'Custom deploy action`'
  task :deploy_bits do
    on roles(:app) do
      if (fetch(:feederout))
        puts "Create feederout directory in webapps"
        execute "cd #{fetch(:deploy_to)}/current/webapps/; mkdir #{fetch(:feederout)};"
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
