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

describe Mongoid::I18n, 'criteria on embeds_many association' do
  before do
    class Entry
      embeds_many :sub_entries
    end

    class SubEntry
      include Mongoid::Document
      include Mongoid::I18n
      localized_field :title
      embedded_in :entry, :inverse_of => :sub_entries
    end
    @entry = Entry.new
    @sub_entries = (0..2).map { @entry.sub_entries.build }
  end

  it "should return a LocalizedCriteria" do
    @entry.sub_entries.criteria.should be_a(Mongoid::I18n::LocalizedCriteria)
  end

  it "should contain the embedded documents" do
    @entry.sub_entries.criteria.instance_variable_get("@documents").should == @sub_entries
  end
end

describe Mongoid::I18n, 'criteria on embeds_one association' do
  before do
    class Entry
      embeds_one :sub_entry
    end

    class SubEntry
      include Mongoid::Document
      include Mongoid::I18n
      localized_field :subtitle
      embedded_in :entry, :inverse_of => :sub_entries
    end
    @entry = Entry.new
  end
  
  it "should store the title in the right locale" do
    @entry.create_sub_entry(:subtitle => "Oxford Street")
    
    @entry.reload
    
    @entry.sub_entry.subtitle.should == 'Oxford Street'
    
    I18n.locale = :nl
    
    @entry.sub_entry.subtitle = 'Hoofdstraat'
    @entry.save
    
    @entry.reload
    
    @entry.sub_entry.subtitle.should == 'Hoofdstraat'
    
    I18n.locale = :en
    
    @entry.sub_entry.subtitle.should == 'Oxford Street'
    
    @entry.sub_entry.subtitle = 'Main Street'
    @entry.save
    
    @entry.reload
    
    @entry.sub_entry.subtitle.should == 'Main Street'
    
  end
end