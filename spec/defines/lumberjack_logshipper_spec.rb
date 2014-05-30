require 'spec_helper'

describe 'lumberjack::logshipper' do

  let(:pre_condition) { 
<<eos
    class { 'lumberjack':
      hosts       => [ 'localhost:4444' ],
      deb_source  => 'puppet:///modules/test/files/deb.file',
      cert_source => 'puppet:///modules/test/files/cert.file',
    }
eos
  }

  context 'defaults' do

    let (:title) { 'nginx' }

    let (:params) { {
      :log_files => [ '/var/log/nginx/*.log' ],
    } }

    it {
      should contain_file('/etc/init/nginx-logshipper.conf')
        .with_ensure('present')

      should contain_file('/etc/lumberjack/nginx-logshipper.json')
        .with_content(/servers\":\s\[\s*\"localhost:4444\"/)
        .with_ensure('present')
      should contain_file('/etc/lumberjack/nginx-logshipper.json')
        .with_content(/paths\":\s\[\s+\"\/var\/log\/nginx\/\*\.log\"/)
      should_not contain_file('/etc/lumberjack/nginx-logshipper.json')
        .with_content(/fields/)

      should contain_service('nginx-logshipper')
        .with({ :ensure => 'running' } )
    }

  end

  context 'absent' do

    let (:title) { 'nginx' }

    let (:params) { {
      :log_files => [ '/var/log/nginx/*.log' ],
      :ensure => 'absent'
    } }

    it {
      should contain_file('/etc/init/nginx-logshipper.conf')
        .with_ensure('absent')

      should contain_file('/etc/lumberjack/nginx-logshipper.json')
        .with_ensure('absent')

      should contain_service('nginx-logshipper')
        .with({ :ensure => 'stopped' } )
    }

  end

  context 'with fields' do
    let (:title) { 'nginx' }
    let (:params) { {
      :log_files => [ '/var/log/nginx/*.log' ],
      :fields => { 'type' => 'nginx' },
    } }

    it {
      should contain_file('/etc/lumberjack/nginx-logshipper.json')
        .with_content(/fields\":\s\{\s+\"type\":\s\"nginx/)
    }
  end

end
