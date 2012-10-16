require './syntax.rb'
require 'rspec/autorun'

describe "structure analysis" do
  
  describe "satzzeichen am ende" do

    it "should assign end_of_input" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      test.end_of_input.should == "."
    end

    it "should manipulate input" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      test.sentence.should == "Gaius Iuliam amat"
    end
  end

  describe "split sentence" do

    it "HS" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      test.structure.should == [["Gaius", "Iuliam", "amat"]] 
    end

    it "HS, NS" do
      test = StructureAnalysis.new("Gaius Iuliam amat, quae puella est.")
      test.structure.should == [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]]
    end

    it "HS, NS, HS" do
      test = StructureAnalysis.new("Gaius Iuliam, quae puella est, amat")
      test.structure.should == [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]]
    end

    it "HS, NS, HS, NS" do
      test = StructureAnalysis.new("Gaius Iuliam, filiam Claudiae, amat, quod puella pulchra est.")
      test.structure.should == [["Gaius", "Iuliam", "amat"], ["filiam", "Claudiae"], ["quod", "puella", "pulchra", "est"]]
    end

    it "tbd" do
      test = StructureAnalysis.new("Inter quas magna discordia orta Iuppiter imperavit Mercurio, ut deas ad Alexandrum Paridem, qui in Ida monte gregem pascebatur, deduceret.")
      test.structure.should == [["Inter", "quas", "magna", "discordia", "orta", "Iuppiter", "imperavit", "Mercurio"], ["ut", "deas", "ad", "Alexandrum", "Paridem", "deduceret"], ["qui", "in", "Ida", "monte", "gregem", "pascebatur"]]
    end
  end
end
