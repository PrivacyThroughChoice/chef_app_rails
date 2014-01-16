#
# Cookbook Name:: thunr-rails
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'ruby_build'
include_recipe "runit"

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

thunr_user = "thunr-rails"

user thunr_user do
  manage_home false
end

db_adapter = node['thunr-rails']['db']['adapter']
db_host = node['thunr-rails']['db']['host']
db_database = node['thunr-rails']['db']['database']
db_username = node['thunr-rails']['db']['username']
db_password = node['thunr-rails']['db']['password']

application 'thunr-rails' do
  owner thunr_user
  group thunr_user
  path '/opt/thunr-rails'
  repository 'git://github.com/thunr/thunr_app_rails.git'
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
