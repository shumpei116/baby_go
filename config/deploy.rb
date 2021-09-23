lock "~> 3.16.0"

set :application, "Baby_Go"
set :repo_url, "git@github.com:shumpei116/baby_go.git"
set :rbenv_ruby, '2.7.4'
set :branch, ENV['BRANCH'] || "main"
set :nginx_config_name, "#{fetch(:application)}.conf"
set :nginx_sites_enabled_path, "/etc/nginx/conf.d"
append :linked_files, "config/master.key", "config/credentials/production.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "node_modules"
