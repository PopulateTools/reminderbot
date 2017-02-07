lock '3.6.1'

set :rails_env, fetch(:stage)
set :application, "reminderbot"
set :repo_url, "https://github.com/PopulateTools/reminderbot.git"
set :linked_files, fetch(:linked_files, []).push('.rbenv-vars', 'config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/cache')
set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
set :rbenv_path, '/home/ubuntu/.rbenv'
set :passenger_restart_with_touch, true
