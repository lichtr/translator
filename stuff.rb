VERBS =  ["oportet", "potest", "coniunxi", "feci", "censeo", "sis", "video", "elaboret", "possis", "videmur", "attulimus", "arbitrentur", "volumus", "utere", "efficies", "est", "consumpsi", "assumo", "videor", "hortor", "aequarunt"]
SUBJ = ["quamquam", "quorum", "ut ", "quam", "quoniam", "quod", "si", "qui ", "nisi"]

class SentenceSplitByCommaAnalysis
  attr_reader :content, :has_subjunction, :has_verb

  def initialize content
    @content = content
    @has_subjunction = has_subjunction
    @has_verb = has_verb
  end

  def has_subjunction
    SUBJ.any? { |x| content.include?(x) }
  end

  def has_verb
    VERBS.any? { |x| content.include?(x) }
  end
end

class StructureAnalysis
  attr_reader :input

  def initialize input
    @input = input
    @end_of_input = end_of_input
    @sentence_split_by_comma = sentence_split_by_comma
  end

  def end_of_input
    input.slice!(-1) if input.match(/[$\.\?!]/)
  end  

  def sentence_split_by_comma
    ssbc = input.split(", ")
    ssbc.map { |x| x = SentenceSplitByCommaAnalysis.new(x) }
  end

  def structure
    SentenceSplitByCommaSorter.new(sentence_split_by_comma).sort
  end
end

class SentenceSplitByCommaSorter
  attr_reader :sentence_split_by_comma

  def initialize sentence_split_by_comma
    @sentence_split_by_comma = sentence_split_by_comma
  end

  def sort
    # Every clause has 2² possible states:
    #    has_subjunction &  has_verb is s1
    #    has_subjunction & !has_verb is s2
    #   !has_subjunction &  has_verb is s3
    #   !has_subjunction & !has_verb is s4
    #

    indexed_ssby = {}
    sentence_split_by_comma.each_with_index { |x, i| indexed_ssby[i] = x }

  end
end


 test = StructureAnalysis.new("quamquam te, Marce fili, annum iam audientem Cratippum idque Athenis abundare oportet praeceptis institutisque philosophiae propter summam et doctoris auctoritatem et urbis, quorum alter te scientia augere potest, altera exemplis, tamen, ut ipse ad meam utilitatem semper cum Graecis Latina coniunxi neque id in philosophia solum, sed etiam in dicendi exercitatione feci, idem tibi censeo faciendum, ut par sis in utriusque orationis facultate.")
p test
