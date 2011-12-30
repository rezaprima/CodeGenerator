require 'field'
require 'generated_class'
class TableParser
  def initialize()

  end

  def parse(specification)
    generated_class = GeneratedClass.new
    generated_class.class_name = specification[:class_name]
    generated_class.table_name = specification[:table_name]
    generated_class.fields = extract_fields(specification[:attributes])
    
    unless specification[:subtables].nil?
      specification[:subtables].each do |subtable|
        generated_class.subtables << parse(subtable)
      end
    end
    return generated_class
  end

  def extract_fields(table_structure, prefix=[])
    result=[]
    table_structure.each do |key,val|
      #TODO extract these 3 lines to new method
      full_field_name = (prefix+[key.to_s]).reject{|entry| entry.nil?}
      result << Field.new(full_field_name.join('_'),val) if (val.is_a? Symbol) || (val.is_a? String)
      result << Field.new(full_field_name.join('_'),val) if val.is_a? Array
      result += extract_fields(val,full_field_name) if val.is_a? Hash
    end
    return result
  end
end
