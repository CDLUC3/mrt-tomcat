lock '>= 3.17.1'

# persistent dirs
# now using puppet to manage tomcat configs, so add tomcat conf/ and bin/ dirs to shared area.
set :linked_dirs, %w{logs temp work conf bin}
set :tmp_dir, "/tmp"

# Default value for keep_releases is 5
set :keep_releases, 5


namespace :deploy do

  desc 'Initialize CATALINA_HOME'
  task :init_catalina_home do
    on roles(:app) do
      execute "[ ! -f #{fetch(:deploy_to)} ] && mkdir -p #{fetch(:deploy_to)};"
    end
  end
  after "git:check", "deploy:init_catalina_home"

  desc 'Download WAR File'
  task :download_bits do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}"
      set :build_url, ask('Enter Jenkins artifact URL: ', 'http://builds.cdlib.org/...') unless fetch(:build_url)
      execute "curl --fail --location --silent --output #{fetch(:tmp_dir)}/#{fetch(:target)} '#{fetch(:build_url)}' || exit 1;"
    end
  end
  after "deploy:check:linked_dirs", "deploy:download_bits"

  desc 'Symlink tomcat to current'
  task :symlink_tomcat do
    on roles(:app) do
      execute "[ ! -f #{fetch(:deploy_to)}/current ] && cd #{fetch(:deploy_to)}; ln -s current tomcat;"
    end
  end
  after "deploy:log_revision", "deploy:symlink_tomcat"

  desc 'Deploy WAR File'
  task :deploy_bits do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}"
      execute "[ ! -f #{fetch(:deploy_to)}/current/webapps ] && mkdir -p #{fetch(:deploy_to)}/current/webapps;"
      invoke 'custom:deploy_bits'
      execute "mv -f #{fetch(:tmp_dir)}/#{fetch(:target)} #{fetch(:deploy_to)}/current/webapps || exit 1;"
    end
  end
  after "deploy:symlink_tomcat", "deploy:deploy_bits"

  desc 'Update Deployment Log'
  task :deploy_log do
    on roles(:app) do
      puts "Log deployment time and semantic version to Tomcat directory"
      set :timestamp, -> { `/usr/bin/date +"%Y%m%d-%H.%M.%S"`.chomp }
      execute "/usr/bin/echo \"#{fetch(:timestamp)}\t#{fetch(:semantic_version)}\" >> #{fetch(:deploy_to)}/deployment_log"
    end
  end
  after "deploy:deploy_bits", "deploy:deploy_log"

end
