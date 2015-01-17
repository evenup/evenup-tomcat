require 'spec_helper'

describe 'tomcat', :type => :class do
  let(:facts) { { :disposition => 'prod', :concat_basedir => '/var/lib/puppet/concat', :osfamily => 'RedHat', :id => '0', :path => '/tmp' } }

  it { should create_class('tomcat::service') }
  it { should contain_service('tomcat').with(
    'ensure'  => 'running',
    'enable'  => true
  ) }

  context 'not managed' do
    let(:params) { { :manage_service => false } }
    it { should_not contain_service('tomcat') }
  end

end
