#!/usr/bin/env rspec
require 'spec_helper'

describe 'ssh::client' do
  describe 'Basic class setup' do
    it { should contain_class('ssh::params') }
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
end
