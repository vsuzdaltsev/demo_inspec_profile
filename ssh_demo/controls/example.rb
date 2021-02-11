#!/usr/bin/env ruby
# frozen_string_literal: true

require 'inspec'

control 'ssh-1.0' do
  input('os_type', value: 'uname -a')

  impact 1.0
  title 'Ssh driven tests of ec2'

  desc 'Demo tests'

  tag environment: 'dev'
  tag maintainer: 'azure devops'

  only_if('Os is not linux') do
    os.linux?
  end

  describe command(input('os_type')) do
    its('stdout') { should cmp %r{GNU/Linux} }
  end

  describe.one do
    %w[vim nano libreoffice].each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end

  describe service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  %w[snowagent opsramp-agent falcon-sensor].each do |agent|
    describe service(agent) do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

