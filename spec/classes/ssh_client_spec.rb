#!/usr/bin/env rspec
require 'spec_helper'

describe 'ssh::client' do
  describe 'Basic class setup' do
    let(:facts) { { :osfamily => 'RedHat' }}
    it { should contain_class('ssh::params') }
    it { should contain_class('ssh::client') }
  end

  describe 'test RedHat functions' do

    let(:facts) { { :osfamily => 'RedHat' }}

    describe 'RedHat should get openssh-clients package' do
      it { should contain_package('openssh-clients') }
    end
  end

  describe 'test Debian related' do
    let(:facts) { { :osfamily => 'Debian' }}

    describe 'Debian uses ssh-clients package' do
      it { should contain_package('openssh-client') }
    end
  end
  describe 'SSH Option checks' do
    let(:facts) { { :osfamily => 'RedHat' }}
    describe 'Should set pubkey to yes' do
      it { should contain_ssh_config('PubkeyAuthentication').with('value' => 'yes') }
    end
    describe 'Should Protocol to 2' do
      it { should contain_ssh_config('Protocol').with('value' => '2') }
    end
  end
  describe 'Non-Default values for config options' do

    let(:facts) { { :osfamily => 'RedHat' }}

    let(:params) { {
      :protocol => '1,2',
      :pubkeyauthentication => 'no'
    } }
    describe 'Allow Protocol' do
      it { should contain_ssh_config('Protocol').with('value' => '1,2') }
    end
    describe 'Allow PubkeyAuthentication' do
      it { should contain_ssh_config('PubkeyAuthentication').with('value' => 'no') }
    end
  end
  describe 'Error handling for broken parameter values' do
    let(:facts) { { :osfamily => 'RedHat' }}
    describe 'broken protocol' do
      let (:params) { { :protocol => 'Moo' } }
      it 'should fail' do
        should raise_error(Puppet::Error)
      end
    end
    describe 'broken pubkeyauthentication' do
      let (:params) { { :pubkeyauthentication => 'Moo' } }
      it 'should fail' do
        should raise_error(Puppet::Error)
      end
    end
  end
end
