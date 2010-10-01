# encoding: utf-8
require 'spec_helper'

describe Mongoid::Localizable do
  before do
    @class = Class.new do
      include Mongoid::Localizable
    end
    I18n.stubs(:locale).returns(:en)
  end
  
  describe "criteria" do
    it "should return a LocalizedCriteria" do
      @class.criteria.should be_a(Mongoid::I18n::LocalizedCriteria)
    end
  end
end
