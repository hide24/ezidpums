#MySQL
MYSQL_HOST = 'db'
MYSQL_ROOT_USER = 'root'
MYSQL_ROOT_PASSWORD = ENV['MYSQL_ROOT_PASSWORD'] || 'password'

#LDAP
LDAP_HOST = 'ldap'
LDAP_BASE_DN = ENV['LDAP_BASE_DN'] || 'dc=foo,dc=bar,dc=org'
LDAP_BIND_DN = ENV['LDAP_BIND_DN'] || 'cn=admin,dc=foo,dc=bar,dc=org'
LDAP_BIND_PASSWORD = ENV['LDAP_BIND_PASSWORD'] || 'password'
LDAP_ACCOUNT_BASE_DN_ALL = {
  'production' => 'ou=production,' + LDAP_BASE_DN,
  'development' => 'ou=development,' + LDAP_BASE_DN,
  'test' => 'ou=test,' + LDAP_BASE_DN,
}
LDAP_ACCOUNT_BASE_DN = LDAP_ACCOUNT_BASE_DN_ALL[Rails.env]

#IdP
IDP_HOST_NAME = ENV['IDP_HOST_NAME'] || 'idp'
IDP_ENTITY_ID = 'https://%s/idp/shibboleth' % IDP_HOST_NAME
IDP_SCOPE = ENV['IDP_SCOPE'] || 'foo.org'
SHIBBOLETH_CONFIG_DIR = '/opt/shibboleth-idp/conf'
SHIBBOLETH_METADATA_DIR = '/opt/shibboleth-idp/metadata'
SHIBBOLETH_CERT_DIR = '/opt/shibboleth-idp/credentials'
