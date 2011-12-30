# To change this template, choose Tools | Templates
# and open the template in the editor.

class HibernateDaoInterfaceGenerator
  def initialize
    @the_domain = Erubis::Eruby.new(File.read("../templates/daointerface.cs.erb"), :pattern => '\[% %\]')
  end

  def process(data)
    @the_domain.result(data)
  end

  def write(data)
    class_name = data[:class_name]
    File.open("../output/Dao/Dao/I#{class_name}Dao.cs",'w') {|f| f.write(process(data))}
    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name, :table_name =>subtable.table_name, :fields => subtable.fields, :subtables => [])
    end
  end
end
