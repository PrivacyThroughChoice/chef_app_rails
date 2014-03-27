name             'chef_app_rails'
maintainer       'Fraser Scott'
maintainer_email 'admin@privacythroughchoice.org'
license          'All rights reserved'
description      'Installs/Configures chef_app_rails'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends 'application_ruby'
depends 'apt'
depends 'user'
depends 'ruby_build'
depends 'runit'
