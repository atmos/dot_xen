require File.dirname(__FILE__) + '/../spec_helper'

if ENV['DO_EM_ALL']
  describe XenConfigFile::Parser, " simple_parsing " do
    before(:all) do
      @parser = XenConfigFile::Parser.new
    end
  
    Dir["#{ENV['EY_FILES'] || File.expand_path(File.dirname(__FILE__)+'/../../../scrapetacular')}/xen/*/*/*.xen"].each do |input_file|
      # next unless input_file =~ /(ey01-s00429|ey01-s00294|ey00-s00124|ey00-s00309|ey00-s00166|ey00-s00112|ey00-s00074)/
      # describe "#{File.basename(input_file)} as input" do
      describe "#{input_file} as input" do
        before(:all) do
          @result = @parser.simple_parse(File.read(input_file))
        end
        it "shouldn't be nil" do
          @result.should_not be_nil
        end
        it "should return an AST instance of the config file" do
          @result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
        end
      end
    end
  end
end