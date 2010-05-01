# encoding: utf-8
require 'spec_helper'

class Entry
  include Mongoid::Document
  include Mongoid::I18n
  
  localized_field :title
  field :published, :type => Boolean
end

describe Mongoid::I18n, "localized_field" do
  describe "with an assigned value" do
    before do
      I18n.locale = :en
      @entry = Entry.new(:title => 'Title')
    end
    
    it "should return that value" do
      @entry.title.should == 'Title'
    end
    
    describe "when the locale is changed" do
      before do
        I18n.locale = :es
      end
      
      it "should return a blank value value" do
        @entry.title.should be_blank
      end
      
      describe "a new value is assigned" do
        before do
          @entry.title = 'Título'
        end
        
        it "should return the new value" do
          @entry.title.should == 'Título'
        end
        
        describe "getter.translations" do
          it "should return all translations" do
            @entry.title_translations.should == {:en => 'Title', :es => 'Título'}
          end
        end
        
        describe "getter.translations=" do
          before do
            @entry.title_translations = {:en => 'New title', :es => 'Nuevo título'}
          end
          
          it "should accept new translations" do
            @entry.title_translations.should == {:en => 'New title', :es => 'Nuevo título'}
          end
          
          it "the setter should return the new translation" do
            @entry.title.should == 'Nuevo título'
          end
        end
        
        describe "and we go back to the original locale" do
          before do
            I18n.locale = :en
          end
          
          it "should return the original value" do
            @entry.title.should == 'Title'
          end
        end
      end
    end
  end
end