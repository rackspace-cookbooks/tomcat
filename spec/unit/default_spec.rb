
require 'spec_helper'

describe 'rackspace_tomcat::default' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'centos', version: '6.4').converge(described_recipe) }

  it 'installs tomcat package' do
    expect(chef_run).to install_package('tomcat6')
  end

  it 'create endorsed directory' do
    expect(chef_run).to create_directory('/usr/share/tomcat6/lib/endorsed')
  end

  it 'enables a service named tomcat' do
    expect(chef_run).to enable_service('tomcat6')
  end

  it "creates /etc/sysconfig/tomcat6" do
    expect(chef_run).to create_template('/etc/sysconfig/tomcat6')
  end

  it "creates /etc/tomcat6/server.xml" do
    expect(chef_run).to create_template('/etc/tomcat6/server.xml')
  end

  it "creates /etc/tomcat6/logging.properties" do
    expect(chef_run).to create_template('/etc/tomcat6/logging.properties')
  end
end
