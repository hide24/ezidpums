class OrganizationalUnit < ActiveLdap::Base
  ldap_mapping dn_attribute: "ou",
               prefix: '',
               classes: ['organizationalUnit'],
               scope: :one
end
