
require 'spec_helper'

describe 'rackspace_tomcat::default' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'centos', version: '6.4').converge(described_recipe) }

  it 'installs tomcat package' do
    expect(chef_run).to install_package("tomcat#{node['rackspace_tomcat']['base_version']}")
  end

  it 'create endorsed directory' do
    expect(chef_run).to create_directory("{node['rackspace_tomcat']['endorsed_dir']}")
  end

  it 'enables a service named tomcat' do
    expect(chef_run).to enable_service("tomcat#{node['rackspace_tomcat']['base_version']}")
  end

  it "creates /etc/sysconfig/tomcat#{node['rackspace_tomcat']['base_version']}" do
    expect(chef_run).to create_template("/etc/sysconfig/tomcat#{node['rackspace_tomcat']['base_version']}")
  end

  it "creates /etc/default/tomcat#{node['rackspace_tomcat']['base_version']}" do
    expect(chef_run).to create_template("/etc/default/tomcat#{node['rackspace_tomcat']['base_version']}")
  end

  it "creates #{node['rackspace_tomcat']['config_dir']}/server.xml" do
    expect(chef_run).to create_template("#{node['rackspace_tomcat']['config_dir']}/server.xml")
  end

  it "creates #{node['rackspace_tomcat']['config_dir']}/logging.properties" do
    expect(chef_run).to create_template("#{node['rackspace_tomcat']['config_dir']}/logging.properties")
  end

  it 'creates a cookbook_file with an explicit action' do
    expect(chef_run).to create_cookbook_file('/tmp/explicit_action')
  end


end

