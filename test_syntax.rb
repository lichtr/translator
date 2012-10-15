require './syntax.rb'
require 'minitest/autorun'

describe "structure analysis" do
  
  describe "satzzeichen am ende" do
    it "should assign end_of_input" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      assert_equal ".", test.end_of_input
    end

    it "should manipulate input" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      assert_equal "Gaius Iuliam amat", test.sentence
    end
  end

  describe "split sentence" do
    it "HS split" do
      test = StructureAnalysis.new("Gaius Iuliam amat.")
      assert_equal [["Gaius", "Iuliam", "amat"]], test.structure
    end

    it "HS,NS split" do
      test = StructureAnalysis.new("Gaius Iuliam amat, quae puella est.")
      assert_equal [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]], test.structure
    end

    it "HS, NS, HS" do
      test = StructureAnalysis.new("Gaius Iuliam, quae puella est, amat")
      assert_equal [["Gaius", "Iuliam", "amat"], ["quae", "puella", "est"]], test.structure 
    end
  end
end
