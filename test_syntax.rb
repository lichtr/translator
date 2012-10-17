require './syntax.rb'
require 'rspec/autorun'

describe StructureAnalysis do
  let :test do
    StructureAnalysis.new(@i)
  end
  
  describe "satzzeichen am ende" do

    it "should assign end_of_input" do
      @i = "Gaius Iuliam amat."
      test.end_of_input.should == "."
    end

    it "should manipulate input" do
      @i = "Gaius Iuliam amat."
      test.sentence.should == "Gaius Iuliam amat"
    end
  end

  describe "#structure" do
    let :test do
      StructureAnalysis.new(@i).structure
    end

    it "HS" do
      @i = "Gaius Iuliam amat."
      test.should == [["Gaius", "Iuliam", "amat"]] 
    end

    it "HS, NS" do
      @i = "Gaius Iuliam amat, quae puella est"
      test.should == [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]]
    end

    it "HS, NS, HS" do
      @i = "Gaius Iuliam, quae puella est, amat."
      test.should == [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]]
    end

    it "HS, NS, HS, NS" do
      @i = "Gaius Iuliam, filiam Claudiae, amat, quod puella pulchra est."
      test.should == [["Gaius", "Iuliam", "amat"], ["filiam", "Claudiae"], ["quod", "puella", "pulchra", "est"]]
    end

    it "HS, NS1, NS2, NS1" do
      @i = "Inter quas magna discordia orta Iuppiter imperavit Mercurio, ut deas ad Alexandrum Paridem, qui in Ida monte gregem pascebatur, deduceret."
      test.should == [["Inter", "quas", "magna", "discordia", "orta", "Iuppiter", "imperavit", "Mercurio"], ["ut", "deas", "ad", "Alexandrum", "Paridem", "deduceret"], ["qui", "in", "Ida", "monte", "gregem", "pascebatur"]]
    end

    it "HS, App, HS, NS1, NS2, NS1" do
      @i = "Aeetae, Solis filio, erat responsum tam diu eum regnum habiturum, quamdiu ea pellis, quam Phrixus consecraverat, in fano Martis esset."
    end
  end
end

describe StructurePrinter do
  describe "string" do
    before :each do
      @print = StructurePrinter.new(
        "Inter quas magna discordia orta Iuppiter imperavit Mercurio, ut deas ad Alexandrum Paridem, qui in Ida monte gregem pascebatur, deduceret", 
        ".", 
        [["Inter", "quas", "magna", "discordia", "orta", "Iuppiter", "imperavit", "Mercurio"], 
          ["ut", "deas", "ad", "Alexandrum", "Paridem", "deduceret"], 
          ["qui", "in", "Ida", "monte", "gregem", "pascebatur"]])
    end

    it "returns proper string representation" do
      @print.string.should == "Inter quas magna discordia orta Iuppiter imperavit Mercurio,\n  ut deas ad Alexandrum Paridem,\n    qui in Ida monte gregem pascebatur,\n  deduceret."
    end
  end
end



