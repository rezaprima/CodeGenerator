class AspxFormGenerator
  def initialize
    p "main_form"
    @main_form = Erubis::Eruby.new(File.read("../templates/form.aspx.erb"), :pattern => '\[% %\]')
    p "main_form_cs"
    @main_form_cs = Erubis::Eruby.new(File.read("../templates/form.aspx.cs.erb"), :pattern => '\[% %\]')
    @redirecting_form = Erubis::Eruby.new(File.read("../templates/redirecting_form.aspx.erb"), :pattern => '\[% %\]')
    @redirecting_form_cs = Erubis::Eruby.new(File.read("../templates/redirecting_form.aspx.cs.erb"), :pattern => '\[% %\]')
    @web_xml = Erubis::Eruby.new(File.read("../templates/web.xml.erb"), :pattern => '\[% %\]')
    @web_xml_string=''
  end

  def write_redirecting_forms(data)
    %w(Add Edit Detail Delete).each do |action|
      data[:action]=action
      class_name = data[:class_name]
      prefix_path = ''
      prefix_path = data[:prefix_path] if data[:prefix_path]
      File.open("../output/Web/src/#{prefix_path}/#{action}#{class_name}.aspx",'w') {|f| f.write(@redirecting_form.result(data))}
      File.open("../output/Web/src/#{prefix_path}/#{action}#{class_name}.aspx.cs",'w') {|f| f.write(@redirecting_form_cs.result(data))}
    end
  end

  def write(data)
    class_name = data[:class_name]
    prefix_path = data[:prefix_path]
    not_write_web_xml = false
    not_write_web_xml = data[:not_write_web_xml] if data.has_key?(:not_write_web_xml)
    p "Form.aspx"
    File.open("../output/Web/src/#{prefix_path}/Form#{class_name}.aspx",'w') {|f| f.write(@main_form.result(data))}
    p "Form.aspx.cs"
    File.open("../output/Web/src/#{prefix_path}/Form#{class_name}.aspx.cs",'w') {|f| f.write(@main_form_cs.result(data))}
    @web_xml_string += @web_xml.result(data)
    write_redirecting_forms(data)

    data[:subtables].each do |subtable|
      self.write(:class_name => subtable.class_name,
        :table_name =>subtable.table_name,
        :fields => subtable.fields,
        :ordinary_fields => subtable.ordinary_fields,
        :subtables => [], :references => [],:prefix_path=>prefix_path,
        :not_write_web_xml => true
      )
    end
    File.open("../output/Web/#{class_name}.web.xml",'w'){|f| f.write(@web_xml_string)} unless not_write_web_xml
  end
end
