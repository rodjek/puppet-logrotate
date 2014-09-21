require 'spec_helper'

describe 'logrotate' do

  let :default_params do
    {
      :packages   => 'logrotate',
      :rules      => {
          messages => {
            path         => '/var/log/messages',
            rotate       => 5,
            rotate_every => 'week',
            postrotate   => '/usr/bin/killall -HUP syslogd',
          },
          apache => {
            path          => '/var/log/httpd/*.log',
            rotate        => 5,
            mail          => 'test@example.com',
            size          => '100k',
            sharedscripts => true,
            postrotate    => '/etc/init.d/httpd restart',
          }
      },
      :hieramerge   => true,
    }

  end

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

    should contain_class('logrotate::rules').with({
      'require' => 'Package[logrotate]',
    })

  end

  context 'on Debian' do
    let(:facts) { {:osfamily => 'Debian'} }

    it {
      should contain_class('logrotate::defaults::debian').with({
        'require' => 'Package[logrotate]',
      })
    }

  end

  context 'on RedHat' do
    let(:facts) { {:osfamily => 'RedHat'} }

    it {
      should contain_class('logrotate::defaults::redhat').with({
        'require' => 'Package[logrotate]',
      })
    }
  end

  context 'on SuSE' do
    let(:facts) { {:osfamily => 'SuSE'} }

    it {
      should contain_class('logrotate::defaults::suse').with({
        'require' => 'Package[logrotate]',
      })
    }

  end

  context 'on Gentoo' do
    let(:facts) { {:operatingsystem => 'Gentoo'} }

    it { should_not contain_class('logrotate::defaults::debian') }
    it { should_not contain_class('logrotate::defaults::redhat') }
    it { should_not contain_class('logrotate::defaults::suse') }
  end

end
