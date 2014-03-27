#
# Cookbook Name:: rackspace_tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2014, Rackspace US, Inc.
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
#

# required for the secure_password method from the openssl cookbook
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'java'

tomcat_pkgs = value_for_platform(
  'default' => ["tomcat#{node['rackspace_tomcat']['base_version']}"],
  )
if node['rackspace_tomcat']['deploy_manager_apps']
  tomcat_pkgs << value_for_platform(
    %w{ debian ubuntu } => {
      'default' => "tomcat#{node['rackspace_tomcat']['base_version']}-admin",
    },
    %w{ centos redhat } => {
      'default' => "tomcat#{node['rackspace_tomcat']['base_version']}-admin-webapps",
    },
    )
end

tomcat_pkgs.compact!

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory node['rackspace_tomcat']['endorsed_dir'] do
  mode '0755'
  recursive true
end

unless node['rackspace_tomcat']['deploy_manager_apps']
  directory "#{node['rackspace_tomcat']['webapp_dir']}/manager" do
    action :delete
    recursive true
  end
  file "#{node['rackspace_tomcat']['config_dir']}/Catalina/localhost/manager.xml" do
    action :delete
  end
  directory "#{node['rackspace_tomcat']['webapp_dir']}/host-manager" do
    action :delete
    recursive true
  end
  file "#{node['rackspace_tomcat']['config_dir']}/Catalina/localhost/host-manager.xml" do
    action :delete
  end
end

service 'tomcat' do
  case node['platform_family']
  when 'rhel'
    service_name "tomcat#{node['rackspace_tomcat']['base_version']}"
    supports restart: true, status: true
  when 'debian'
    service_name "tomcat#{node['rackspace_tomcat']['base_version']}"
    supports restart: true, reload: false, status: true
  end
  action [:enable, :start]
  notifies :run, 'execute[wait for tomcat]', :immediately
  retries 4
  retry_delay 30
end

execute 'wait for tomcat' do
  command 'sleep 5'
  action :nothing
end

node.set_unless['rackspace_tomcat']['keystore_password'] = secure_password
node.set_unless['rackspace_tomcat']['truststore_password'] = secure_password

unless node['rackspace_tomcat']['truststore_file'].nil?
  java_options = node['rackspace_tomcat']['java_options'].to_s
  java_options << " -Djavax.net.ssl.trustStore=#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['truststore_file']}"
  java_options << " -Djavax.net.ssl.trustStorePassword=#{node['rackspace_tomcat']['truststore_password']}"

  node.set['rackspace_tomcat']['java_options'] = java_options
end

case node['platform_family']
when 'rhel'
  template "/etc/sysconfig/tomcat#{node['rackspace_tomcat']['base_version']}" do
    cookbook node['rackspace_tomcat']['templates_cookbook']['sysconfig_tomcat6']
    source 'sysconfig_tomcat6.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[tomcat]'
  end
when 'debian'
  template "/etc/default/tomcat#{node['rackspace_tomcat']['base_version']}" do
    cookbook node['rackspace_tomcat']['templates_cookbook']['default_tomcat6']
    source 'default_tomcat6.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[tomcat]'
  end
end

template "#{node['rackspace_tomcat']['config_dir']}/server.xml" do
  cookbook node['rackspace_tomcat']['templates_cookbook']['server_xml']
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[tomcat]'
end

template "#{node['rackspace_tomcat']['config_dir']}/logging.properties" do
  cookbook node['rackspace_tomcat']['templates_cookbook']['logging_properties']
  source 'logging.properties.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[tomcat]'
end

if node['rackspace_tomcat']['ssl_cert_file'].nil?
  execute 'Create Tomcat SSL certificate' do
    group node['rackspace_tomcat']['group']
    command "#{node['rackspace_tomcat']['keytool']} -genkeypair -keystore \"#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['keystore_file']}\" -storepass \"#{node['rackspace_tomcat']['keystore_password']}\" -keypass \"#{node['rackspace_tomcat']['keystore_password']}\" -dname \"#{node['rackspace_tomcat']['certificate_dn']}\""
    umask 0007
    creates "#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['keystore_file']}"
    action :run
    notifies :restart, 'service[tomcat]'
  end
else
  script 'create_tomcat_keystore' do
    interpreter 'bash'
    action :nothing
    cwd node['rackspace_tomcat']['config_dir']
    code <<-EOH
      cat #{node['rackspace_tomcat']['ssl_chain_files'].join(' ')} > cacerts.pem
      openssl pkcs12 -export \
      -inkey #{node['rackspace_tomcat']['ssl_key_file']} \
      -in #{node['rackspace_tomcat']['ssl_cert_file']} \
      -chain \
      -CAfile cacerts.pem \
      -password pass:#{node['rackspace_tomcat']['keystore_password']} \
      -out #{node['rackspace_tomcat']['keystore_file']}
    EOH
    notifies :restart, 'service[tomcat]'
  end

  cookbook_file "#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['ssl_cert_file']}" do
    mode '0644'
    notifies :run, 'script[create_tomcat_keystore]'
  end

  cookbook_file "#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['ssl_key_file']}" do
    mode '0644'
    notifies :run, 'script[create_tomcat_keystore]'
  end

  node['rackspace_tomcat']['ssl_chain_files'].each do |cert|
    cookbook_file "#{node['rackspace_tomcat']['config_dir']}/#{cert}" do
      mode '0644'
      notifies :run, 'script[create_tomcat_keystore]'
    end
  end
end

unless node['rackspace_tomcat']['truststore_file'].nil?
  cookbook_file "#{node['rackspace_tomcat']['config_dir']}/#{node['rackspace_tomcat']['truststore_file']}" do
    mode '0644'
  end
end
