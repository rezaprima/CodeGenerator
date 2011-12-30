require 'table_parser'
class GeneratedClass
  attr_accessor :class_name, :table_name, :fields, :subtables

  def initialize(table_specification=nil)
    @subtables = []
    unless table_specification.nil?
      @class_name = table_specification[:class_name]
      @table_name = table_specification[:table_name]
      @fields = TableParser.new.extract_fields(table_specification)
    end
  end
  def primary_key
    @primary_key ||= @fields.select{ |field| field.primary_key? }.first
  end

  def subtable_references
    @primary_key ||= @fields.select{ |field| field.subtable_reference? }
  end

  def ordinary_fields
    special_field_names=%w(intCreatedBy dtCreatedDate intUpdatedBy dtUpdatedDate intApprovedBy dtApprovedDate  intAuthorizedBy dtAuthorizedDate)
    @fields.reject{|f| f.primary_key? || special_field_names.include?(f.name)}
  end

  def title_name
    @table_name.to_s.split('_').map{|word| word.capitalize}.join(' ')
  end
end
