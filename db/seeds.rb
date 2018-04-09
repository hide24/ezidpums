# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# IdProvider must be exists one record.
IdProvider.create(name: '', entity_id: IDP_ENTITY_ID, scope: IDP_SCOPE, host_name: IDP_HOST_NAME)

# Set up minimam LDAP attributes
ldap_attribute_yml =<<-EOY
uid:
  id: 1
  order: 1
  name: uid
  field_type_id: 0
  enable: true

displayName:
  id: 2
  order: 2
  name: displayName
  field_type_id: 0
  enable: true

mail:
  id: 3
  order: 3
  name: mail
  field_type_id: 0
  enable: true

userPassword:
  id: 4
  order: 4
  name: userPassword
  field_type_id: 2
  enable: true


eduPersonEntitlement:
  id: 5
  order: 5
  name: eduPersonEntitlement
  field_type_id: 1
  enable: true

o:
  id: 6
  order: 6
  name: o
  field_type_id: 0
  enable: true

ou:
  id: 7
  order: 7
  name: ou
  field_type_id: 0
  enable: true

EOY

ldap_attributes = YAML.load(ldap_attribute_yml)
ldap_attributes.each do |id, ldap_attribute|
  LdapAttribute.create(ldap_attribute)
end

# Set up minimum IdP attributes
idp_attribute_yml =<<-YOM
eppn:
  id: 1
  order: 1
  name: eduPersonPrincipalName
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Scoped" id="eduPersonPrincipalName" scope="%{idp.scope}" sourceAttributeID="uid">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML1ScopedString" name="urn:mace:dir:attribute-def:eduPersonPrincipalName" encodeType="false" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2ScopedString" name="urn:oid:1.3.6.1.4.1.5923.1.1.1.6" friendlyName="eduPersonPrincipalName" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true

targetedId:
  id: 2
  order: 2
  name: eduPersonTargetedId
  attribute_resolver: |+
    <resolver:DataConnector id="computedID" xsi:type="dc:ComputedId"
                            generatedAttributeID="computedID"
                            sourceAttributeID="%{idp.persistentId.sourceAttribute}"
                            salt="%{idp.persistentId.salt}">
        <resolver:Dependency ref="%{idp.persistentId.sourceAttribute}" />
    </resolver:DataConnector>
  enable: false

displayName:
  id: 3
  order: 3
  name: displayName
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Simple" id="jaDisplayName" sourceAttributeID="displayName;lang-ja">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:1.3.6.1.4.1.32264.1.1.3" friendlyName="jaDisplayName" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true

mail:
  id: 4
  order: 4
  name: mail
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Simple" id="mail" sourceAttributeID="mail">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:dir:attribute-def:mail" encodeType="false" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:0.9.2342.19200300.100.1.3" friendlyName="mail" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true

eduPersonEntitlement:
  id: 5
  order: 5
  name: eduPersonEntitlement
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Simple" id="eduPersonEntitlement" sourceAttributeID="eduPersonEntitlement">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:dir:attribute-def:eduPersonEntitlement" encodeType="false" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:1.3.6.1.4.1.5923.1.1.1.7" friendlyName="eduPersonEntitlement" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true

organizationName:
  id: 6
  order: 6
  name: organizationName
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Simple" id="organizationName" sourceAttributeID="o">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:dir:attribute-def:o" encodeType="false" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:2.5.4.10" friendlyName="o" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true
    
organizationalUnitName:
  id: 7
  order: 7
  name: organizationalUnitName
  attribute_resolver: |+
    <resolver:AttributeDefinition xsi:type="ad:Simple" id="organizationalUnitName" sourceAttributeID="ou">
        <resolver:Dependency ref="myLDAP" />
        <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:dir:attribute-def:ou" encodeType="false" />
        <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:2.5.4.11" friendlyName="ou" encodeType="false" />
    </resolver:AttributeDefinition>
  enable: true
    
YOM

idp_attributes = YAML.load(idp_attribute_yml)
idp_attributes.each do |id, idp_attribute|
  IdpAttribute.create(idp_attribute)
end

ActiveLdap::Populate.ensure_base(Account, ou_base_class: ActiveLdap::Base)


