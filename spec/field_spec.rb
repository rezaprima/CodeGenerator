# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'field'

describe Field do
  before(:each) do
    @field = Field.new('abc_def',:string)
  end

  it "should give column name" do
    @field.column_name.should == 'ABC_DEF'
  end
end

