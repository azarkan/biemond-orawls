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
      # Batch resources don't have persistent state - always return empty to force creation
      []
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create batch JMS resources for #{name}"
      content = template('puppet:///modules/orawls/providers/wls_jms_batch/create.py.erb', binding)
      Puppet.debug "Generated script length: #{content.length} bytes"
      Puppet.debug "Script contains real_domain: #{content.include?("real_domain='#{domain}")}"
      content
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify batch JMS resources for #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_batch/create.py.erb', binding)
    end

    on_destroy  do | command_builder |
      wlst_action = 'destroy'
      Puppet.info "destroy batch JMS resources for #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_batch/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :timeout
    
    newparam(:queues) do
      desc 'Hash of JMS queues to create'
    end
    
    newparam(:topics) do
      desc 'Hash of JMS topics to create'
    end
    
    newparam(:connection_factories) do
      desc 'Hash of JMS connection factories to create'
    end
    
    newparam(:subdeployments) do
      desc 'Hash of JMS subdeployments to create'
    end
    
    newparam(:jms_servers) do
      desc 'Hash of JMS servers to create'
    end
    
    newparam(:quotas) do
      desc 'Hash of JMS quotas to create'
    end

    add_title_attributes(:jmsmodule) do
      /^((.*?\/)?(.*))$/
    end
  end
end
