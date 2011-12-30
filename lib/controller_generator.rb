require 'rubygems'
require 'erubis'

class ControllerGenerator
  def initialize
    @interface = Erubis::Eruby.new(File.read("../templates/IHibernateController.cs.erb"), :pattern => '\[% %\]')
    @implementer = Erubis::Eruby.new(File.read("../templates/NHibernateController.cs.erb"), :pattern => '\[% %\]')
  end

  def write(data)
    classname = data[:class_name]
    File.open("../output/Web/App_Code/BeanController/I#{classname}Controller.cs",'w') {|f| f.write(@interface.result(data))}
    File.open("../output/Web/App_Code/BeanController/NHibernate#{classname}Controller.cs",'w') {|f| f.write(@implementer.result(data))}
    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name, :table_name =>subtable.table_name, :fields => subtable.fields, :subtables => [])
    end
  end

end
