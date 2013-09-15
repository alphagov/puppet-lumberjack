require 'spec_helper'

describe 'lumberjack' do

  context 'defaults' do
    let (:params) { {
      :host => 'localhost',
      :deb_source => 'puppet:///modules/test/deb.file',
      :cert_source => 'puppet:///modules/test/cert.file',
    } }

    it {
      should contain_file('/var/tmp/lumberjack.deb')
      should contain_file('/etc/ssl/lumberjack.pub').
        with({ :mode => '0400' })
      should contain_package('lumberjack')
      should contain_file('/etc/lumberjack')
    }
  end

end
