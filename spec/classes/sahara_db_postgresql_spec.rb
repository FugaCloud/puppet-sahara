require 'spec_helper'

describe 'sahara::db::postgresql' do

  shared_examples_for 'sahara::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('sahara').with(
        :user     => 'sahara',
        :password => 'md59b1dd0cc439677764ef5a848112ef0ab'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'sahara::db::postgresql'
    end
  end

end
