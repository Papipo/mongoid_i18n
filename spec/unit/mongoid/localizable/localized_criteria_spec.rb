require 'spec_helper'

describe Mongoid::Localizable::LocalizedCriteria do
  describe "where" do
    before do
      @title = Mongoid::Field.new(:title, :type => Mongoid::I18n::LocalizedField)
      @published = Mongoid::Field.new(:published, :type => Boolean)
      klass = stub(:fields => {'title' => @title, 'published' => @published})
      @criteria = Mongoid::Localizable::LocalizedCriteria.new(klass)
      @criteria.where(:title.in => ['Title'], :published => true)
    end
    
    it "should expand fields that are LocalizedFields" do
      @criteria.instance_variable_get("@selector").should == {'title.en' => {'$in' => ['Title']}, :published => true}
    end
  end
end
