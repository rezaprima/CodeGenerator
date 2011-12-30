require 'rubygems'
require 'erubis'

class HbmXmlGenerator
  def initialize
    @the_domain = Erubis::Eruby.new(File.read("../templates/nhibernate.hbm.xml.erb"), :pattern => '\[% %\]')
  end

  def process(data)
    @the_domain.result(data)
  end

  def write(data)
    class_name = data[:class_name]
    File.open("../output/Dao.NHibernate/Mappings/#{class_name}.hbm.xml",'w') {|f| f.write(process(data))}
    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name, 
        :table_name =>subtable.table_name,
        :fields => subtable.fields, :subtables => [], :references => [data[:main_class]])
    end

  end

end
