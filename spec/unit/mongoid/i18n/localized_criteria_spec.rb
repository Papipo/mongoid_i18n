require 'spec_helper'

describe Mongoid::I18n::LocalizedCriteria do
  describe "where" do
    before do
      klass = stub(:fields => {'title' => mock(:type => Mongoid::I18n::LocalizedField), 'published' => mock(:type => Boolean)})
      @criteria = Mongoid::I18n::LocalizedCriteria.new(klass)
      @criteria.where(:title.in => ['Title'], :published => true)
    end
    
    it "should expand fields that are LocalizedFields" do
      @criteria.instance_variable_get("@selector").should == {'title.en' => {'$in' => ['Title']}, :published => true}
    end
  end
end