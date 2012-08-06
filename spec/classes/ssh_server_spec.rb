#!/usr/bin/env rspec
require 'spec_helper'

describe 'ssh::server' do
  describe 'Basic class setup' do
    it { should contain_class('ssh::params') }
  end
  describe 'test RedHat functions' do

    let(:facts) { { :osfamily => 'RedHat' }}

    describe 'RedHat should get openssh-server package' do
      it { should contain_package('openssh-server') }
    end
  end

  describe 'test Debian related' do
    let(:facts) { { :osfamily => 'Debian' }}

    describe 'Debian uses ssh-server package' do
      it { should contain_package('ssh-server') }
    end
  end
end
