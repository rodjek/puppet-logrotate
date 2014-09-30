require 'spec_helper'

describe 'logrotate::base' do
  context 'input validation' do
    ['purge','backup'].each do |bools|
      context "when #{bools} is not a boolean" do
        let (:params){{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools
    ['pkg_ensure','pkg_name'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings
  end
  ['logrotate','mylogrotate'].each do |pkg_names|
    context "when pkg_name has the value of #{pkg_names}" do
      ['latest','present','somever==1.0*'].each do |pkg_ensure_vals|
        context "when pkg_ensure has the value of #{pkg_ensure_vals}" do
          let (:params) {{'pkg_ensure' => pkg_ensure_vals,'pkg_name' => pkg_names}}
          it {should contain_package(pkg_names).with_ensure(pkg_ensure_vals).with_alias('logrotate')}
        end
      end
    end
  end
  ['purge','backup'].each do |booltest|
    [true,false].each do |boolval|
      context "when #{booltest} is #{boolval}" do
        let (:params){{booltest => boolval }}
        it {should contain_file('/etc/logrotate.d').with({
          'ensure'  => 'directory',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0755',
          booltest  => boolval,
          'require' => 'Package[logrotate]',
        })}
      end
    end
  end
  it do
    should contain_file('/etc/logrotate.conf').with({
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0444',
      'source'  => 'puppet:///modules/logrotate/etc/logrotate.conf',
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
  ['Debian','RedHat','SuSE'].each do |osfam|
    context "on #{osfam}" do
      let(:facts) {{ :osfamily => osfam}}
      it { should contain_class("logrotate::defaults::#{osfam.downcase}")}
      ['purge','backup'].each do |bools|
        context "when #{bools} is not a boolean" do
          let (:params){{bools => "BOGON"}}
          it 'should fail' do
            expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end
    end
  end
  context 'on Gentoo' do
    let(:facts) { {:operatingsystem => 'Gentoo'} }

    it { should_not contain_class('logrotate::defaults::debian') }
    it { should_not contain_class('logrotate::defaults::redhat') }
    it { should_not contain_class('logrotate::defaults::suse') }
  end
end
