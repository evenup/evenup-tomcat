require 'spec_helper'

describe 'tomcat::vhost', :type => :define do
  let(:title) { 'myvhost' }
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  context 'default' do
    it { should contain_file('/usr/share/tomcat/sites/myvhost').with_mode('0775') }
    it { should contain_concat__fragment('server_xml_myvhost').with(
      :target   => '/usr/share/tomcat/conf/server.xml'
    ) }

  end

  context 'hostname' do
    let(:params) { { :hostname => 'myhost' } }
    it { should contain_file('/usr/share/tomcat/sites/myhost').with_mode('0775') }
  end

  context 'vagrant node' do
    let(:facts) { { :disposition => 'vagrant', :concat_basedir => '/var/lib/puppet/concat' } }
    it { should contain_file('/usr/share/tomcat/sites/myvhost').with_mode('0777') }
  end

  context 'dev node' do
    let(:facts) { { :disposition => 'dev', :concat_basedir => '/var/lib/puppet/concat' } }
    it { should contain_file('/usr/share/tomcat/sites/myvhost').with_mode('0777') }
  end


end
