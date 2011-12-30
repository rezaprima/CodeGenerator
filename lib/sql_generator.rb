class SqlGenerator
  def initialize
    @the_domain = Erubis::Eruby.new(File.read("../templates/create_query.sql.erb"), :pattern => '\[% %\]')
  end

  def process(data)
    @the_domain.result(data)
  end

  def write(data)
    table_name = data[:table_name]
    File.open("../output/#{table_name}.sql",'w') {
      |f| f.write(process(data))
      data[:subtables].each do |subtable|
        f.write(process(:class_name => subtable.class_name,
          :table_name =>subtable.table_name,
          :fields => subtable.fields,
          :subtables => [], :references => []))
      end
    }
  end
end
