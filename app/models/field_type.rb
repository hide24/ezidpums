class FieldType
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  def persisted?
    false
  end

  FieldTypes = [
    {name: 'text', description: 'short string, length < 256', form: [:text_field, {class: 'form-control'}], display: nil},
    {name: 'long text', description: 'long string, up to 64k', form: [:text_area, {rows: 10, class: 'form-control'}], display: nil},
    {name: 'password', description: 'password field', form: [:password_field, {class: 'form-control'}], display: '********'},
  ]

  def self.find(id)
    self.new(id)
  end

  def self.all
    (0...FieldTypes.size).map do |i|
      self.find(i)
    end
  end

  def self.options
    self.all.map{|field_type| [field_type.name, field_type.id]}
  end

  def initialize(id)
    @id = id.to_i
    @field_type = FieldTypes[@id]
  end

  def id
    @id
  end

  def name
    @field_type[:name]
  end

  def description
    @field_type[:description]
  end

  def form
    @field_type[:form]
  end

  def display
    @field_type[:display]
  end
end
