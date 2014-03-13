
require 'spec_helper'

describe 'rackspace_tomcat::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
end

