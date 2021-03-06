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
  'production' => 'ou=production,%s' % LDAP_BASE_DN,
  'development' => 'ou=development%s,' % LDAP_BASE_DN,
  'test' => 'ou=test,%s' % LDAP_BASE_DN,
}
LDAP_ACCOUNT_BASE_DN = LDAP_ACCOUNT_BASE_DN_ALL[Rails.env]

#IdP
IDP_HOST = 'idp'
IDP_HOST_NAME = ENV['IDP_HOST_NAME']
IDP_ENTITY_ID = 'https://%s/idp/shibboleth' % IDP_HOST_NAME
IDP_SCOPE = ENV['IDP_SCOPE']
SHIBBOLETH_CONFIG_DIR = '/opt/shibboleth-idp/conf'
SHIBBOLETH_METADATA_DIR = '/opt/shibboleth-idp/metadata'
SHIBBOLETH_CERT_DIR = '/opt/shibboleth-idp/credentials'

HTTP_SSL_CERT_DIR = '/opt/httpd/certs'
HTTP_SSL_KEY_DIR = '/opt/httpd/certs'
JETTY_KEYSTORE_PASSWORD = ENV['JETTY_KEYSTORE_PASSWORD']
