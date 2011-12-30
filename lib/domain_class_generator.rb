require 'rubygems'
require 'erubis'

class DomainClassGenerator
  def initialize
    @the_domain = Erubis::Eruby.new(File.read("../templates/domain.cs.erb"), :pattern => '\[% %\]')
  end

  def process(data)
    @the_domain.result(data)
  end

  def write(data)
    classname = data[:class_name]
    File.open("../output/Dao/Domain/#{classname}.cs",'w') {|f| f.write(process(data))}
    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name, 
        :table_name =>subtable.table_name,
        :fields => subtable.fields,
        :subtables => [],
        :references => [data[:main_class]]
      )
    end
  end

end
