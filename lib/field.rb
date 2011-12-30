class Field
  def initialize(key,val)
    @fieldname = key
    value = val.is_a?(Array) ? val.first : val
    @primary_key = val.is_a?(Array) && val.include?(:primary_key)
    if val.is_a?(Array)&& val.include?(:reference)
      @reference = true
      @reference_class_name = val[2]
      @reference_key = val[3]
    end
    if val.is_a?(Array) && val.include?(:lookup)
      @lookup = true
      @lookup_category = val.last
    end
    if val.is_a?(Array) && val.include?(:subtable_reference)
      @subtable_reference = true
      @reference_class_name = val[2]
      @reference_key = val[3]
    end
    @nullable = ((value.to_s)[-1] == ?? )
    @datatype = @nullable ? value.to_s[0..-2].to_sym : value.to_sym
  end

  def reference?
    @reference
  end

  def subtable_reference?
    @reference
  end

  def reference_class_name
    @reference_class_name
  end

  def reference_key
    @reference_key
  end

  def lookup?
    @lookup
  end

  def lookup_category
    @lookup_category
  end

  def primary_key?
    @primary_key
  end
  
  def boolean?
    (@datatype == :boolean)
  end
  def string?
    (@datatype == :string)
  end
  def numeric?
    (@datatype == :number) || (@datatype == :money)
  end
  def datetime?
    (@datatype == :datetime) || (@datatype == :date)
  end
  def nullable?
    @nullable
  end
  def required?
    !@nullable
  end
  def datatype
    nullable? ? (csharp_datatype+'?') : csharp_datatype
  end

  def plain_name
    @fieldname.to_s.split('_').map{|word| word.capitalize}.join
  end
  def name
    prefix+plain_name
  end
  def name_with_prefix
    prefix+plain_name
  end
  def column_name
    @fieldname.to_s.upcase
  end
  def title_name
    @fieldname.to_s.gsub('_id_pk','').split('_').map{|word| word.capitalize}.join(' ')
  end

  def csharp_datatype
    return 'Boolean' if boolean?
	  return 'Decimal' if numeric?
	  return 'DateTime' if datetime?
	  return 'String' if string?
	  return 'ERROR'
  end

  def sql_type
    return 'INT' if boolean?
	  return 'NUMBER' if numeric?
	  return 'DATE' if datetime?
	  return 'VARCHAR(255)' if string?
	  return 'ERROR'
  end

  private
  def prefix
    return 'int' if numeric?
    return 'str' if string?
    return 'dt' if datetime?
    return 'is' if boolean?
  end
end
