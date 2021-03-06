require 'spec_helper'

describe 'sahara::logging' do

  let :params do
    {
    }
  end

  let :log_params do
    {
      :debug                         => 'true',
      :use_syslog                    => 'true',
      :use_stderr                    => 'false',
      :log_facility                  => 'LOG_LOCAL0',
      :log_dir                       => '/tmp/sahara',
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix   => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix      => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append             => '/etc/sahara/logging.conf',
      :publish_errors                => true,
      :default_log_levels            => {
        'amqp'       => 'WARN',
        'amqplib'    => 'WARN',
        'boto'       => 'WARN',
        'sqlalchemy' => 'WARN',
        'suds'       => 'INFO',
        'iso8601'    => 'WARN',
        'requests.packages.urllib3.connectionpool' => 'WARN' },
     :fatal_deprecations             => true,
     :instance_format                => '[instance: %(uuid)s] ',
     :instance_uuid_format           => '[instance: %(uuid)s] ',
     :log_date_format                => '%Y-%m-%d %H:%M:%S',
    }
  end

  shared_examples_for 'sahara-logging' do

    context 'with basic logging options defaults' do
      it_behaves_like 'basic logging options defaults'
    end

    context 'with basic logging options passed' do
      before { params.merge!( log_params ) }
      it_behaves_like 'basic logging options passed'
    end

    context 'with extended logging options' do
      before { params.merge!( log_params ) }
      it_behaves_like 'logging params set'
    end

    context 'without extended logging options' do
      it_behaves_like 'logging params unset'
    end

  end

  shared_examples_for 'basic logging options defaults' do

    context 'with defaults' do
     it { is_expected.to contain_oslo__log('sahara_config').with(
        :use_syslog => '<SERVICE DEFAULT>',
        :use_stderr => '<SERVICE DEFAULT>',
        :log_dir    => '/var/log/sahara',
        :debug      => '<SERVICE DEFAULT>',
      )}
    end

    context 'with syslog enabled and default log facility' do
      let :params do
        { :use_syslog   => 'true' }
      end

      it { is_expected.to contain_oslo__log('sahara_config').with(
        :use_syslog          => true,
        :syslog_log_facility => '<SERVICE DEFAULT>',
      )}
    end
  end

  shared_examples_for 'basic logging options passed' do
    context 'with passed params' do
      it { is_expected.to contain_oslo__log('sahara_config').with(
        :use_syslog          => true,
        :use_stderr          => false,
        :syslog_log_facility => 'LOG_LOCAL0',
        :log_dir             => '/tmp/sahara',
        :debug               => true,
      )}
    end
  end

  shared_examples_for 'logging params set' do
    it 'enables logging params' do
      is_expected.to contain_oslo__log('sahara_config').with(
        :logging_context_format_string =>
          '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
        :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
        :logging_debug_format_suffix   => '%(funcName)s %(pathname)s:%(lineno)d',
        :logging_exception_prefix      => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
        :log_config_append             => '/etc/sahara/logging.conf',
        :publish_errors                => true,
        :default_log_levels            => {
          'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
          'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
          'requests.packages.urllib3.connectionpool' => 'WARN' },
       :fatal_deprecations             => true,
       :instance_format                => '[instance: %(uuid)s] ',
       :instance_uuid_format           => '[instance: %(uuid)s] ',
       :log_date_format                => '%Y-%m-%d %H:%M:%S',
      )
    end
  end

  shared_examples_for 'logging params unset' do
   [ :logging_context_format_string, :logging_default_format_string,
     :logging_debug_format_suffix, :logging_exception_prefix,
     :log_config_append, :publish_errors,
     :default_log_levels, :fatal_deprecations,
     :instance_format, :instance_uuid_format,
     :log_date_format, ].each { |param|
        it { is_expected.to contain_oslo__log('sahara_config').with("#{param}" => '<SERVICE DEFAULT>') }
      }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end
      it_behaves_like 'sahara-logging'
    end
  end

end
