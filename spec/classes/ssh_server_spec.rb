#!/usr/bin/env rspec
$:.unshift File.join(File.dirname(__FILE__), '..', 'fixtures/modules/augeasproviders/lib')

require 'spec_helper'

describe 'ssh::server' do
  describe 'Basic class setup' do
    it { should contain_class('ssh::params') }
  end
  describe 'test RedHat functions' do

    let(:facts) { { :osfamily => 'RedHat' }}

    describe 'RedHat should get openssh-server package' do
      it { should contain_package('ssh-server').with({ 'ensure' => 'present',
                                                     'name' => 'openssh-server' } ) }
    end

  end

  describe 'test Debian related' do
    let(:facts) { { :osfamily => 'Debian' }}

    describe 'Debian uses ssh-server package' do
      it { should contain_package('ssh-server').with_ensure('present') }
    end

  end

  describe 'Non OS specific' do
    describe 'ssh service should be running' do
      it { should contain_service('ssh').with_ensure('running') }
    end
  end

  describe 'SSH Option checks' do
    describe 'Should not allow rhosts' do
      it { should contain_sshd_config('IgnoreRhosts').with('value' => 'No') }
    end
    describe 'Should not allow host based auth' do
      it { should contain_sshd_config('HostbasedAuthentication').with('value' => 'No') }
    end
    describe 'Not permit root login by default' do
      it { should contain_sshd_config('PermitRootLogin').with('value' => 'No') }
    end
    describe 'Not permit empty password' do
      it { should contain_sshd_config('PermitEmptyPasswords').with('value' => 'No') }
    end
    describe 'Set the loglevel to INFO' do
      it { should contain_sshd_config('LogLevel').with('value' => 'INFO') }
    end
    describe 'Enforce strict modes' do
      it { should contain_sshd_config('StrictModes').with('value' => 'Yes') }
    end
    describe 'Should disable TCPKeepAlive' do
      it { should contain_sshd_config('TCPKeepAlive').with('value' => 'No') }
    end
    describe 'Should enable ClientAliveInterval with a default of 60 seconds' do
      it { should contain_sshd_config('ClientAliveInterval').with('value' => '60') }
    end
    describe 'Should set the ClientAliveCountMax to 3 by default' do
      it { should contain_sshd_config('ClientAliveCountMax').with('value' => '3') }
    end
    describe 'Should enable Privilege seperation by default' do
      it { should contain_sshd_config('UsePrivilegeSeperation').with('value' => 'Yes') }
    end
    describe 'Should set MaxAuthTries to 2 by default' do
      it { should contain_sshd_config('MaxAuthTries').with('value' => '2') }
    end
    describe 'Disable Password auth by default' do
      it { should contain_sshd_config('PasswordAuthentication').with('value' => 'No') }
    end
    describe 'Should disable PAM by default' do
      it { should contain_sshd_config('UsePAM').with('value' => 'No') }
    end
    describe 'Should disable Kerberos by default' do
      it { should contain_sshd_config('KerberosAuthentication').with('value' => 'No') }
    end
    describe 'Disable GSSAPI Authentication' do
      it { should contain_sshd_config('GSSAPIAuthentication').with('value' => 'No') }
    end
    describe 'Not have any allowed users by default' do
      it { should_not contain_sshd_config('AllowUsers') }
    end
  end
  
  describe 'Non-Default values for config options' do
    let(:params) { {
      :permitroot => 'Yes',
      :aliveinterval => '600',
      :alivecount => '5',
      :privilegeseperation => 'No',
      :maxauth => '5',
      :passwordauth => 'Yes',
      :usepam => 'Yes',
      :kerberosauth => 'Yes'
    } }
    describe 'Allow Root Login if specified' do
      it { should contain_sshd_config('PermitRootLogin').with('value' => 'Yes') }
    end
    describe 'Allow a non-default numeric ClientAliveInterval' do
      it { should contain_sshd_config('ClientAliveInterval').with('value' => '600') }
    end
    describe 'Allow a non-default numeric ClientAliveCountMax' do
      it { should contain_sshd_config('ClientAliveCountMax').with('value' => '5') }
    end
    describe 'Allow setting PrivilegeSeperation to no' do
      it { should contain_sshd_config('UsePrivilegeSeperation').with('value' => 'No') }
    end
    describe 'Allow us to change MaxAuthRetries' do
      it { should contain_sshd_config('MaxAuthTries').with('value' => '5') }
    end
    describe 'Allow us to use password authentication' do
      it { should contain_sshd_config('PasswordAuthentication').with('value' => 'Yes') }
    end
    describe 'Allow us to use PAM' do
      it { should contain_sshd_config('UsePAM').with('value' => 'Yes') }
    end
    describe 'Allow use of kerberos auth' do
      it { should contain_sshd_config('KerberosAuthentication').with('value' => 'Yes') }
    end
  end

  describe 'Error handling for broken parameter values' do
    describe 'broken permitroot' do
      let (:params) { { :permitroot => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'aliveinternal not a number' do
      let (:params) { { :aliveinterval => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'alivecount not a number' do
      let (:params) { { :alivecount => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'privilegeseperation not yes or no' do
      let (:params) { { :privilegeseperation => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'maxauth not a number' do
      let (:params) { { :maxauth => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'passwordauth not yes or no' do
      let (:params) { { :passwordauth => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'usepam not yes or no' do
      let (:params) { { :usepam => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
    describe 'kerberosauth not yes or no' do
      let (:params) { { :kerberosauth => 'Moo' } }
      it 'should fail' do
        expect { should include_class('ssh::server') }.to raise_error(Puppet::Error)
      end
    end
  end

  describe 'Array based config items' do
    let(:params) { { :allowusers => ["user1", "user2"] } }
    describe 'Allow us to send in an array of permitted users' do
      it { should contain_sshd_config('AllowUsers').with('value' => ["user1", "user2"]) }
    end
  end
end
