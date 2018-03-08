class Account < ActiveLdap::Base
  ldap_mapping dn_attribute: "uid",
               prefix: "ou=accounts",
               classes: ['inetOrgPerson', 'eduPerson'],
               scope: :one
  before_create :digest_password
  before_update :digest_password
  before_validation :dup_user_name

  def digest_password
    return if user_password.blank? || /\{MD5\}/ =~ user_password
    password_digest = '{MD5}' + Base64.encode64(Digest::MD5.digest(user_password)).chomp
    self.user_password = password_digest
  end

  def dup_user_name
    self.cn = displayName
    self.sn = displayName
  rescue
    # fix for ActiveLdap::Populate#ensure_ou bug.
    # it calls this callback illegally.
   true
  end
end
