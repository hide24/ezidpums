class Organization < ActiveLdap::Base
  ldap_mapping dn_attribute: "o",
               prefix: '',
               classes: ['organization'],
               scope: :one
end
