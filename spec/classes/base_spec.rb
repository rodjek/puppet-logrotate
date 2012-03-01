require 'spec_helper'

describe 'logrotate::base' do
  it do
    should contain_package('logrotate').with_ensure('latest')

    should contain_file('/etc/logrotate.conf').with({
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0444',
      'source'  => 'puppet:///modules/logrotate/etc/logrotate.conf',
      'require' => 'Package[logrotate]',
    })

    should contain_file('/etc/logrotate.d').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
      'require' => 'Package[logrotate]',
    })

    should contain_file('/etc/cron.daily/logrotate').with({
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0555',
      'source'  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate',
      'require' => 'Package[logrotate]',
    })
  end
end
