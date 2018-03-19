#MySQL
MYSQL_HOST = 'db'
MYSQL_ROOT_USER = 'root'
MYSQL_ROOT_PASSWORD = ENV['MYSQL_ROOT_PASSWORD']

#LDAP
LDAP_HOST = 'ldap'
LDAP_BASE_DN = ENV['LDAP_BASE_DN']
LDAP_BIND_DN = ENV['LDAP_BIND_DN']
LDAP_BIND_PASSWORD = ENV['LDAP_BIND_PASSWORD']
LDAP_ACCOUNT_BASE_DN_ALL = {
  'production' => 'ou=production,' + LDAP_BASE_DN,
  'development' => 'ou=development,' + LDAP_BASE_DN,
  'test' => 'ou=test,' + LDAP_BASE_DN,
}
LDAP_ACCOUNT_BASE_DN = LDAP_ACCOUNT_BASE_DN_ALL[Rails.env]

#IdP
SHIBBOLETH_CONFIG_DIR = '/opt/shibboleth-idp/conf'
SHIBBOLETH_METADATA_DIR = '/opt/shibboleth-idp/metadata'
SHIBBOLETH_CERT_DIR = '/opt/shibboleth-idp/credentials'
