#
# Cookbook Name:: rackspace_tomcat
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2014, Rackspace US, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['rackspace_tomcat']['base_version'] = 6
default['rackspace_tomcat']['port'] = 8080
default['rackspace_tomcat']['proxy_port'] = nil
default['rackspace_tomcat']['ssl_port'] = 8443
default['rackspace_tomcat']['ssl_proxy_port'] = nil
default['rackspace_tomcat']['ajp_port'] = 8009
default['rackspace_tomcat']['catalina_options'] = ''
default['rackspace_tomcat']['java_options'] = '-Xmx128M -Djava.awt.headless=true'
default['rackspace_tomcat']['use_security_manager'] = false
default['rackspace_tomcat']['authbind'] = 'no'
default['rackspace_tomcat']['deploy_manager_apps'] = true
default['rackspace_tomcat']['ssl_max_threads'] = 150
default['rackspace_tomcat']['ssl_cert_file'] = nil
default['rackspace_tomcat']['ssl_key_file'] = nil
default['rackspace_tomcat']['ssl_chain_files'] = [ ]
default['rackspace_tomcat']['keystore_file'] = 'keystore.jks'
default['rackspace_tomcat']['keystore_type'] = 'jks'
default['rackspace_tomcat']['truststore_file'] = nil
default['rackspace_tomcat']['truststore_type'] = 'jks'
default['rackspace_tomcat']['certificate_dn'] = 'cn=localhost'
default['rackspace_tomcat']['loglevel'] = 'INFO'
default['rackspace_tomcat']['tomcat_auth'] = 'true'

case node['platform_family']
when 'rhel'
  default['rackspace_tomcat']['user'] = 'tomcat'
  default['rackspace_tomcat']['group'] = 'tomcat'
  default['rackspace_tomcat']['home'] = "/usr/share/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['base'] = "/usr/share/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['config_dir'] = "/etc/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['log_dir'] = "/var/log/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['tmp_dir'] = "/var/cache/tomcat#{node['rackspace_tomcat']['base_version']}/temp"
  default['rackspace_tomcat']['work_dir'] = "/var/cache/tomcat#{node['rackspace_tomcat']['base_version']}/work"
  default['rackspace_tomcat']['context_dir'] = "#{node['rackspace_tomcat']['config_dir']}/Catalina/localhost"
  default['rackspace_tomcat']['webapp_dir'] = "/var/lib/tomcat#{node['rackspace_tomcat']['base_version']}/webapps"
  default['rackspace_tomcat']['keytool'] = '/usr/lib/jvm/java/bin/keytool'
  default['rackspace_tomcat']['lib_dir'] = "#{node['rackspace_tomcat']['home']}/lib"
  default['rackspace_tomcat']['endorsed_dir'] = "#{node['rackspace_tomcat']['lib_dir']}/endorsed"
when 'debian'
  default['rackspace_tomcat']['user'] = "tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['group'] = "tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['home'] = "/usr/share/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['base'] = "/var/lib/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['config_dir'] = "/etc/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['log_dir'] = "/var/log/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['tmp_dir'] = "/tmp/tomcat#{node['rackspace_tomcat']['base_version']}-tmp"
  default['rackspace_tomcat']['work_dir'] = "/var/cache/tomcat#{node['rackspace_tomcat']['base_version']}"
  default['rackspace_tomcat']['context_dir'] = "#{node['rackspace_tomcat']['config_dir']}/Catalina/localhost"
  default['rackspace_tomcat']['webapp_dir'] = "/var/lib/tomcat#{node['rackspace_tomcat']['base_version']}/webapps"
  default['rackspace_tomcat']['keytool'] = '/usr/lib/jvm/default-java/bin/keytool'
  default['rackspace_tomcat']['lib_dir'] = "#{node['rackspace_tomcat']['home']}/lib"
  default['rackspace_tomcat']['endorsed_dir'] = "#{node['rackspace_tomcat']['lib_dir']}/endorsed"
end
