#
# Cookbook Name:: thunr-rails
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'git'

user "thunr-rails" do
  manage_home false
end

execute 'apt-key update' do
  command 'apt-key update'
  action :nothing
end

apt_repository 'brightbox' do
  uri 'http://ppa.launchpad.net/brightbox/ruby-ng-experimental/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver "keyserver.ubuntu.com"
  key 'C3173AA6'
  action :add
  notifies :run, "execute[apt-key update]", :immediately
end

%w[ ruby2.0 ruby2.0-dev libsqlite3-dev ].each do |pkg|
  package pkg
end

gem_package 'bundler'

template '/etc/init.d/thunr-rails' do
  source 'unicorn_init.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    :app_name => 'thunr-rails',
    :app_root => '/opt/thunr-rails/current',
    :pid => '/opt/thunr-rails/shared/tmp/pids/unicorn.pid',
    :timeout => 60,
    :env => 'development',
    :user => 'thunr-rails'
  )
end

unicorn_config '/etc/unicorn/thunr-rails.rb' do
  listen({ 9000 => {} })
  preload_app true
  working_directory '/opt/thunr-rails/current'
  pid '/tmp/thurn-rails.sock'
  worker_processes 1
  worker_timeout 15
end

directory '/opt/thunr-rails/shared/tmp/pids' do
  owner 'thunr-rails'
  group 'thunr-rails'
  mode 0755
  recursive true
end

execute 'bundle install' do
  command 'bundle install'
  cwd '/opt/thunr-rails/current'
  action :nothing
  notifies :restart, 'service[thunr-rails]', :delayed
end

application 'thunr-rails' do
  path '/opt/thunr-rails'
  owner 'thunr-rails'
  group 'thunr-rails'
  repository 'https://github.com/thunr/thunr_app_railstest.git'
  revision 'master'
  #notifies :run, 'execute[bundle install]', :delayed
end

service 'thunr-rails' do
  supports :status => true, :restart => true, :reload => true
  action :enable
end
