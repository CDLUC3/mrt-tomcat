#lock '>= 3.17.0'

# persistent dirs
# now using puppet to manage tomcat configs, so add tomcat conf and bin dirs to shared area.
set :linked_dirs, %w{logs temp work conf bin}
set :tmp_dir, "/tmp"


# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Download WAR File'
  task :download_bits do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}"
      set :build_url, ask('Enter Jenkins artifact URL: ', 'http://builds.cdlib.org/...') unless fetch(:build_url)
      execute "curl --location --silent --output #{fetch(:tmp_dir)}/#{fetch(:target)} '#{fetch(:build_url)}' || exit 1;"
    end
  end
  after "deploy", "deploy:download_bits"
  before "deploy:download_bits", "init_deploy"

  desc 'Deploy WAR File'
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
      execute "[ ! -f #{fetch(:deploy_to)}/current ] && cd #{fetch(:deploy_to)}; ln -s current tomcat;"
    end
  end

end
