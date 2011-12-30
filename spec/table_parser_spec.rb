# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'table_parser'

describe TableParser do
  before(:each) do
    @table_parser = TableParser.new
  end

  it "should parse basic column definition" do
    fields = @table_parser.extract_fields({:fieldname=>:string})
    fields.length.should == 1
    fields.first.should be_string
    fields.first.name.should == 'strFieldname'
  end

  it "should parse optional column definition" do
    fields = @table_parser.extract_fields({:fieldname=>:string?})
    fields.length.should == 1
    fields.first.should be_string
    fields.first.should be_nullable
  end

  it "should parse column definition with primary key attribute" do
    fields = @table_parser.extract_fields({:fieldname=>[:number,:primary_key]})
    fields.first.should be_numeric
    fields.first.should be_primary_key
  end

  it "should parse composite column definition" do
    fields = @table_parser.extract_fields({:birth => {:date => :datetime, :place => :string }})
    fields.length.should == 2
    fields.first.should be_datetime
    fields.first.name.should == "dtBirthDate"

    fields.last.should be_string
    fields.last.name.should == "strBirthPlace"
  end

  it "should parse basic column definition with prefix" do
    fields = @table_parser.extract_fields({:date => :datetime}, "birth")
    fields.first.name.should == "dtBirthDate"
  end

  it "should parse basic column definition with multi prefix" do
    fields = @table_parser.extract_fields({:date => :datetime}, ["son", "birth"])
    fields.first.name.should == "dtSonBirthDate"
  end

  it "should parse arbitrary depth composite column definition" do
    fields = @table_parser.extract_fields({:birth => {:date => {:hijri => :datetime}}})
    fields.first.name.should == "dtBirthDateHijri"
    fields.first.should be_datetime
  end
end

