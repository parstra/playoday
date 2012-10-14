ssh_options[:forward_agent] = true
set :deploy_to,  "/var/sites/playoday"

require 'bundler/capistrano'
load 'deploy/assets'

set :bundle_flags, "--deployment --quiet --binstubs"
set :application, "playoday"
set :repository,  "git@github.com:railsrumble/r12-team-336.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, 'playoday'
set :use_sudo, false

set :playoday, "178.79.149.69"
set :rails_env, "production"
set :branch, "capcapcap"

set :unicorn_binary, "/usr/local/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

set :deploy_via, :remote_cache

role :web, playoday                          # Your HTTP server, Apache/etc
role :app, playoday                          # This may be the same as your `Web` server
role :db,  playoday, :primary => true # This is where Rails migrations will run


namespace :deploy do
  task :setup_symlinks do
    commands = []
    commands << "test -d #{shared_path}/sockets || mkdir #{shared_path}/sockets"
    commands << "ln -nfs #{shared_path}/sockets #{release_path}/tmp/sockets"
    commands << "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run commands.map{ |cmd| "( #{cmd} )" }.join(' &&  ')
  end
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

after 'deploy:update_code', 'deploy:setup_symlinks'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
