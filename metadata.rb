name             'rackspace_tomcat'
maintainer       'Rackspace US, Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w{ rackspace_java openssl }.each do |cb|
  depends cb
end

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end
