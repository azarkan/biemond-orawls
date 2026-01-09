require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_batch).provide(:simple) do
  include EasyType::Provider
  include Utils::WlsAccess

  mk_resource_methods
  
  # Override exists? to always return false, forcing creation
  # Batch resources don't have persistent state - they're just a wrapper for bulk operations
  def exists?
    Puppet.debug "wls_jms_batch exists? called - returning false to force creation"
    false
  end
  
  # Override create to ensure it's called
  def create
    Puppet.debug "wls_jms_batch create method called"
    super
  end
end
