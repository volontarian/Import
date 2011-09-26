# encoding: utf-8
require 'spec_helper'

describe Import::NoRelation do
  it "should" do
    2.times do
      import = Import::NoRelation.new(:resource_class => Music::Artist, :input => 'Böhse Onkelz')
      
      import.save
      
      import.process
      
      Music::Artist.last.name.should == 'Böhse Onkelz'
    end
    
    Music::Artist.count == 1
  end
end