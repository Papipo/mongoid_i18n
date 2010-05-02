# encoding: utf-8
require 'spec_helper'

describe Mongoid::I18n do
  before do
    @class = Class.new do
      include Mongoid::I18n
    end
    I18n.stubs(:locale).returns(:en)
  end
  
  describe "expand_localized_fields_in_selector" do
    before do
      @class.stubs(:fields).returns('title' => mock(:type => Mongoid::I18n::LocalizedField), 'published' => mock(:type => Boolean))
    end
    
    it "should expand fields that are LocalizedFields" do
      @class.send(:expand_localized_fields_in_selector, :title => 'Title', :published => true).should == {'title.en' => 'Title', :published => true}
    end
  end
end