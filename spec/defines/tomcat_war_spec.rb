require 'spec_helper'

describe 'tomcat::war', :type => :define do
  let(:title) { 'mywar' }
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat', :disposition => 'prod', :osfamily => 'RedHat', :id => '0', :path => '/tmp' } }

  context 'artifactory source' do
    let(:params) { {
      :app      => 'myapp',
      :site     => 'mysite',
      :source   => 'artifactory',
      :version  => '1.2.3',
    } }

    it { should contain_artifactory__fetch_artifact('mywar').with(
      :project  => '',
      :version  => '1.2.3',
      :path     => '',
      :filename => 'myapp.war-1.2.3'
    )}

    it { should contain_file('/usr/share/tomcat/sites/mysite/myapp.war').with(
     :ensure  => 'link',
     :target  => '/usr/share/tomcat/sites/mysite/myapp.war-1.2.3'
    ) }

    it { should contain_exec('clean_/usr/share/tomcat/sites/mysite/myapp').with(
      :command  => 'rm -rf myapp ; mkdir myapp ; unzip myapp.war -d myapp/',
      :cwd      => '/usr/share/tomcat/sites/mysite'
    ) }
  end

  context 'invalid source' do
    let(:params) { {
      :app    => 'myapp',
      :site   => 'mysite',
      :source => 'invalid',
    } }

    it { expect { should raise_error(Puppet::Error) } }
  end

end
