# encoding: utf-8
require 'spec_helper'

class Entry
  include Mongoid::Document
  include Mongoid::I18n
  
  localized_field :title
  field :published, :type => Boolean
end

describe Mongoid::I18n, "localized_field" do
  before do
    I18n.locale = :en
  end
  
  describe "without an assigned value" do
    before do
      @entry = Entry.new
    end
    
    it "should return blank" do
      @entry.title.should be_blank
    end
  end
  
  describe "with an assigned value" do
    before do
      @entry = Entry.new(:title => 'Title')
    end
    
    describe "and persisted" do
      before do
        @entry.save
      end
      
      describe "where() criteria" do
        it "should use the current locale value" do
          Entry.where(:title => 'Title').first.should == @entry
        end
      end
      
      describe "find(:first) with :conditions" do
        it "should use the current locale value" do
          Entry.find(:first, :conditions => {:title => 'Title'}).should == @entry
        end
      end
    end
    
    it "should return that value" do
      @entry.title.should == 'Title'
    end
    
    describe "when the locale is changed" do
      before do
        I18n.locale = :es
      end
      
      it "should return a blank value" do
        @entry.title.should be_blank
      end
      
      describe "a new value is assigned" do
        before do
          @entry.title = 'Título'
        end
        
        it "should return the new value" do
          @entry.title.should == 'Título'
        end
        
        describe "persisted and retrieved from db" do
          before do
            @entry.save
            @entry = Entry.find(:first, :conditions => {:title => 'Título'})
          end
          
          it "the localized field value should be ok" do
            @entry.title.should == 'Título'
            I18n.locale = :en
            @entry.title.should == 'Title'
            @entry.title_translations.should == {'en' => 'Title', 'es' => 'Título'}
          end
        end
        
        describe "getter.translations" do
          it "should return all translations" do
            @entry.title_translations.should == {'en' => 'Title', 'es' => 'Título'}
          end
        end
        
        describe "getter.translations=" do
          before do
            @entry.title_translations = {'en' => 'New title', 'es' => 'Nuevo título'}
          end
          
          it "should accept new translations" do
            @entry.title_translations.should == {'en' => 'New title', 'es' => 'Nuevo título'}
          end
          
          it "the getter should return the new translation" do
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