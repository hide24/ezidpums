ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'erb'
require 'yaml'
require 'rbconfig'
require 'tempfile'

require 'active_ldap'

LDAP_ENV = ENV['RAILS_ENV']

module AlTestUtils
  def dn(string)
    ActiveLdap::DN.parse(string)
  end

  def setup
    @base_dir = File.expand_path(File.dirname(__FILE__))
    @top_dir = File.expand_path(File.join(@base_dir, ".."))
    @fixtures_dir = File.join(@base_dir, "fixtures_al")
    begin
      ActiveLdap::Base.dump(:scope => :sub)
    rescue ActiveLdap::ConnectionError
    end
    ActiveLdap::Base.delete_all(nil, :scope => :sub)
    populate
  end

  def fixtures
    Dir[File.join(@fixtures_dir, '*.yml')].map do |filename|
      [File.basename(filename, '.yml'), filename]
    end
  end

  def populate(klass = ActiveLdap::Base)
    ActiveLdap::Populate.ensure_base(klass, ou_base_class: ActiveLdap::Base)
  end

  def load(names = nil)
    setup unless @fixtures_dir
    @fixtures ||= {}
    fixtures = self.fixtures
    if names.kind_of?(String)
      fixtures = fixtures.select{|klass, filename| klass == names}
    elsif names.kind_of?(Enumerable)
      fixtures = fixtures.select{|klass, filename| names.include?(klass)}
    end
    fixtures.each do |klass, filename|
      @fixtures[klass] = {}
      kklass = klass.camelcase.singularize.constantize
      populate(kklass)
      fixture = YAML.load(File.read(filename))
      fixture.each do |index, values|
        @fixtures[klass][index] = kklass.create(values)
      end
      unless self.respond_to?(klass)
        define_method(klass) do |index|
          @fixtures[klass][index.to_s]
        end
        module_function klass.to_sym
      end
    end
  end

  module_function :dn, :setup, :fixtures,:populate, :load
end
