require 'spec_helper'
hiera_file = 'spec/fixtures/hiera/hiera.yaml'

# NOTE: not supported on puppet versions <= 2.6

describe 'logrotate::rules', :type => :class, :unsupported => 2.6 do

  describe 'with no rules' do
    it { should have_logrotate__rule_resource_count(0) }
  end

  describe 'with rules and no hiera lookup' do
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
      :hieramerge   => false,
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

  describe 'with rules and explicit hiera lookup' do
    let (:hiera_config) { hiera_file }

    hiera       = Hiera.new(:config => hiera_file)
    hieramerge  = hiera.lookup('logrotate::hieramerge', nil, nil)
    rules       = hiera.lookup('logrotate::rules', nil, nil)

    let(:params) { {
      :rules      => rules,
      :hieramerge => hieramerge,
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
