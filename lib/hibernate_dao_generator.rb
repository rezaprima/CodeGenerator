class HibernateDaoGenerator
  def initialize
    @the_domain = Erubis::Eruby.new(File.read("../templates/nhibernate.cs.erb"), :pattern => '\[% %\]')
  end

  def process(data)
    @the_domain.result(data)
  end

  def write(data)
    class_name = data[:class_name]
    File.open("../output/Dao.NHibernate/Dao/NHibernate/Hibernate#{class_name}Dao.cs",'w') {|f| f.write(process(data))}
    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name, :table_name =>subtable.table_name, :fields => subtable.fields, :subtables => [])
    end
  end
end
