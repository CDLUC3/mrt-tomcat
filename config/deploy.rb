# config valid only for Capistrano 3.1
lock '3.4.0'

# Instance specific variables set in deploy/ directory
# set :application, 'merritt-ingest'
# set :repo_url, 'https://hg.cdlib.org/mrt-ingest'
# set :build_url, 'http://builds.cdlib.org/job/mrt-ingest-dev/lastSuccessfulBuild/artifact/batch-war/target/mrt-ingestwar-1.0-SNAPSHOT.war'
# set :deploy_to, '/dpr2/apps/ingest33121/tomcat'
set :scm, :hg

set :stages, ["mrt-ingest-local", "mrt-ingest-dev", "mrt-ingest-stg", "mrt-ingest-prd", 
		"mrt-inv-dev", "mrt-inv-stg", "mrt-inv-prd",
		"mrt-store-dev", "mrt-store-stg", "mrt-store-prd"]
set :default_env, { path: "/dpr2/local/bin:$PATH" }

# persistent dirs
# set :linked_files, %w{webapps/tomcat.pid}
set :linked_dirs, %w{logs temp work}
set :tmp_dir, "/tmp"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Stop Tomcat'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      if test("[ -f #{fetch(:tomcat_pid)} ]")
        invoke 'custom:prestop'
        execute "cd #{fetch(:deploy_to)}/tomcat; /bin/sh ./bin/stop"
      end
    end
  end

  desc 'Start Tomcat'
  task :start do
    on roles(:app), wait: 10 do
      execute "cd #{fetch(:deploy_to)}/tomcat; /bin/sh ./bin/start"
      invoke 'custom:poststart'
    end
  end

  desc 'Status Tomcat'
  task :status do
    on roles(:app) do
      if test("[ -f #{fetch(:tomcat_pid)} ]")
        execute "cd #{fetch(:deploy_to)}/current; cat #{fetch(:tomcat_pid)} | xargs ps -lp"
      end
    end
  end

  desc 'Download Tomcat'
  task :download_bits do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}"
      # execute "[ -f #{fetch(:tmp_dir)}/#{fetch(:target)} ] && rm -f #{deploy_to}/temp/#{fetch(:target});"
      set :build_url, ask('Enter Jenkins artifact URL: ', 'http://builds.cdlib.org/...') unless fetch(:build_url)
      execute "curl --location --silent --output #{fetch(:tmp_dir)}/#{fetch(:target)} '#{fetch(:build_url)}' || exit 1;"
    end
  end
  after "deploy", "deploy:download_bits"
  before "deploy:download_bits", "init_deploy"

  desc 'Deploy Tomcat'
  task :deploy_bits do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}"
      execute "[ ! -f #{fetch(:deploy_to)}/current/webapps ] && mkdir -p #{fetch(:deploy_to)}/current/webapps;"
      invoke 'custom:deploy_bits'
      execute "mv -f #{fetch(:tmp_dir)}/#{fetch(:target)} #{fetch(:deploy_to)}/current/webapps || exit 1;"
    end
  end
  after "deploy:download_bits", "deploy:deploy_bits"
  before "deploy:deploy_bits", "init_deploy"

  desc 'Initial Deploy Tomcat'
  task :init_deploy do
    on roles(:app) do
      execute "[ ! -f #{fetch(:deploy_to)} ] && mkdir -p #{fetch(:deploy_to)};"
      execute "[ ! -f #{fetch(:deploy_to)} ] && cd #{fetch(:deploy_to)}; ln -s current tomcat;"
    end
  end

end
