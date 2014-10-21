require 'spec_helper'

describe 'logrotate::base' do
  it do
    should contain_package('logrotate').with_ensure('latest')

    should contain_file('/etc/logrotate.conf').with({
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0444',
      'content' => "# THIS FILE IS AUTOMATICALLY DISTRIBUTED BY PUPPET.  ANY CHANGES WILL BE\n# OVERWRITTEN.\n\n# Default values\n\nsu root root\n\n# rotate log files weekly\nweekly\n\n# keep 4 weeks worth of backlogs\nrotate 4\n\n# create new (empty) log files after rotating old ones\ncreate\n\n# packages drop log rotation information into this directory\ninclude /etc/logrotate.d\n",
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

  context 'on Debian' do
    let(:facts) { {:osfamily => 'Debian'} }

    it { should contain_class('logrotate::defaults::debian') }
  end

  context 'on RedHat' do
    let(:facts) { {:osfamily => 'RedHat'} }

    it { should contain_class('logrotate::defaults::redhat') }
  end

  context 'on SuSE' do
    let(:facts) { {:osfamily => 'SuSE'} }

    it { should contain_class('logrotate::defaults::suse') }
  end

  context 'on Gentoo' do
    let(:facts) { {:operatingsystem => 'Gentoo'} }

    it { should_not contain_class('logrotate::defaults::debian') }
    it { should_not contain_class('logrotate::defaults::redhat') }
    it { should_not contain_class('logrotate::defaults::suse') }
  end
end
