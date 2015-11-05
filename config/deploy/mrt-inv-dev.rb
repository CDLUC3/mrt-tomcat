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
set :rails_env, "mrt-inv-dev"

puts "----- mrt-inv-dev branch of https://hg.cdlib.org/tomcat8_catalina_base -----"
set :repo_url, "https://hg.cdlib.org/tomcat8_catalina_base"
set :branch, "mrt-inv-dev"

set :application, "merritt-inv"
set :build_url, "http://builds.cdlib.org/job/mrt-inv/lastSuccessfulBuild/artifact/inv-war/dev-dpr2/mrtinv.dev-dpr2.war"
set :target, "mrtinv.war"
set :deploy_to, "/dpr2/apps/inv36121"

set :tomcat_pid, "#{fetch(:deploy_to)}/tomcat.pid"
set :tomcat_log, "#{fetch(:deploy_to)}/shared/log/tomcat.log"

server "mrt-inv-aws-dev.cdlib.org", user: "dpr2", roles: %w{web app}

# custom

namespace :custom do
  desc 'Custom action`'
  task :custom_deploy_bits do
    on roles(:app) do
        puts "No custom actions"
      end
    end
  end
end
