#
# Cookbook Name:: ptc-rails
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'ruby_build'
include_recipe 'runit'

ruby_build_ruby '1.9.3-p448' do
  prefix_path '/usr/local/'
  environment 'CFLAGS' => '-g -O2'
  action :install
end

gem_package 'bundler' do
  version '1.5.0'
  gem_binary '/usr/local/bin/gem'
  options '--no-ri --no-rdoc'
end

ptc_user = "ptc-rails"

user ptc_user do
  manage_home false
end

db_adapter = node['ptc-rails']['db']['adapter']
db_host = node['ptc-rails']['db']['host']
db_database = node['ptc-rails']['db']['database']
db_username = node['ptc-rails']['db']['username']
db_password = node['ptc-rails']['db']['password']

application 'ptc-rails' do
  owner ptc_user
  group ptc_user
  path '/opt/ptc-rails'
  repository 'git://github.com/privacythroughchoice/app_rails.git'
  rails do
    bundler true
    database do
      adapter db_adapter
      host db_host
      database db_database
      username db_username
      password db_password
    end
  end
  unicorn do
    worker_processes 2
  end
end
