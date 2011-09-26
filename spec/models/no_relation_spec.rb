require 'spec_helper'

describe Import::NoRelation do
  it "should" do
    import = Importer::Music::Artist.new(:input => 'Paradise Lost')

    import.save
    
    import.process
    
    Music::Artist.last.name.should == 'Paradise Lost'
  end
end