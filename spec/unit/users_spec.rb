
require 'spec_helper'

describe 'rackspace_tomcat::default' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'centos', version: '6.4').converge(described_recipe) }

  it "creates /etc/tomcat6/tomcat-users.xml" do
    expect(chef_run).to create_template('/etc/tomcat6/tomcat-users.xml')
  end
end
