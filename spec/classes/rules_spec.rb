require 'spec_helper'

describe 'logrotate::rules', :type => :class do

  describe 'with no rules' do
    it { should have_logrotate__rule_resource_count(0) }
  end

  describe 'with rules' do
    let(:params) { {
      :rules      => {
          'messages' => {
            'path'         => '/var/log/messages',
            'rotate'       => 5,
            'rotate_every' => 'week',
            'postrotate'   => '/usr/bin/killall -HUP syslogd',
          },
          'apache' => {
            'path'          => '/var/log/httpd/*.log',
            'rotate'        => 5,
            'mail'          => 'test@example.com',
            'size'          => '100k',
            'sharedscripts' => true,
            'postrotate'    => '/etc/init.d/httpd restart',
          }
      },
      :hieramerge   => true,
    } }

    it 'should have logrotate rule: messages' do
      should contain_logrotate__rule('messages').with({
        :path           => '/var/log/messages',
        :rotate         => 5,
        :rotate_every   => 'week',
        :postrotate     => '/usr/bin/killall -HUP syslogd',
      })
    end

    it 'should have logrotate rule: apache' do
      should contain_logrotate__rule('apache').with({
        :path           => '/var/log/httpd/*.log',
        :rotate         => 5,
        :mail           => 'test@example.com',
        :size           => '100k',
        :sharedscripts  => true,
        :postrotate     => '/etc/init.d/httpd restart',
      })
    end

  end

end
