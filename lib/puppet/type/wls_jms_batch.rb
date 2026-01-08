require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_jms_batch) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to batch create multiple JMS resources in a single WLST transaction for improved performance.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_batch' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_batch/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create batch JMS resources for #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_batch/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify batch JMS resources for #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_batch/create.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy batch JMS resources for #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_batch/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :timeout
    
    property :queues
    property :topics
    property :connection_factories
    property :subdeployments
    property :jms_servers
    property :quotas

    add_title_attributes(:jmsmodule) do
      /^((.*?\/)?(.*))$/
    end
  end
end
