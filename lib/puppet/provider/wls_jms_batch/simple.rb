require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_batch).provide(:simple) do
  include EasyType::Provider
  include Utils::WlsAccess

  mk_resource_methods
end
