require 'spec_helper'

describe 'lumberjack::logshipper' do

  context 'defaults' do

    let (:title) { 'nginx' }

    let (:params) { {
      :log_files => [ '/var/log/nginx/*.log' ],
    } }

    it {
      should contain_file('/etc/init/nginx-logshipper.conf')

      # FIXME: It can't access the vars from the lumberjack 
      # class, config_dir comes through as an empty string
      should contain_file('/nginx-logshipper.json')
        .with_content(/paths\":\s\[\s+\"\/var\/log\/nginx\/\*\.log\"/)
      should_not contain_file('/nginx-logshipper.json')
        .with_content(/fields/)

      should contain_service('nginx-logshipper')
        .with({ :ensure => 'running' } )
    }

  end

  context 'with fields' do
    let (:title) { 'nginx' }
    let (:params) { {
      :log_files => [ '/var/log/nginx/*.log' ],
      :fields => { 'type' => 'nginx' },
    } }

    it {
      should contain_file('/nginx-logshipper.json')
        .with_content(/fields\":\s\{\s+\"type\":\s\"nginx/)
    }
  end

end
