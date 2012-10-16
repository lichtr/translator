CONJUNCTIONS = ["ut", "cum", "qui", "quae", "quod", ]
VERBS = ["amat", "est", "deduceret", "imperavit", "pascebatur"]
PRED = ["amat", "imperavit"]
class StructureAnalysis
  require 'strscan'

  attr_reader :input, :sentence

  def initialize input
    @input = input
    @sentence = sentence
    @end_of_input = end_of_input
  end

  def sentence
    input[-1].match(/[\.\?!]/) ? input.chop : input
  end

  def end_of_input
    match = input[-1].match(/[\.\?!]/)
    unless match.nil?
      match[0]
    end    
  end

  def structure
    structured = []
    tbo = sentence.split(/,/)
    tbo.each { |x| x.strip! }
    tbo = tbo.map { |x| x.split(/\s/) }

    hash = Hash.new
    tbo.each_with_index { |x, i| hash[i] = [x] }
    hash.each do |k,v| 
      (v[0] & VERBS).empty? ? v << false : v << true
      (v[0] & CONJUNCTIONS).empty? ? v << false : v << true
      (v[0] & PRED).empty? ? v << false : v << true
    end

    unless hash.empty?
      hash.each do |k,v|

        case

        when v[1] == false && v[2] == false
          structured << v[0]

        when v[3] == true
          if structured[0].nil?
            structured << v[0]
          else structured[0].concat(v[0])
          end

        when v[1] == true && v[2] == true
          structured << v[0]

        when v[1] == false && v[2] == true && v[3] == false
          hash.each do |x,y|
            if y[1] == true && y[2] == false && y[3] == false
              v[0].concat(y[0])
              hash.delete(x)
            end
          end 
          structured << v[0]
        end
        hash.delete(k)
      end 
    end
    structured
  end
end

# DOCUMENTATION:
# structure needs to know: Conjunctions, all verbs in a sentence, the predicate.
# further analysis needed for AcI/NCI. infinite verb should trigger this
# analysis.
# some conj need different rules: 
#   ut (ind.). 
#   cum (Abl?), 
#   rel.pron (anschluss? pronomen beforehand? (", in quo...")
# while the rest is processing, show the user the structured sentence (nested)
#
#
# PROBLEMS:
#   et, -qui
#   aufzählungs commas should NOT be a problem. they will split the sentence
#   initially, but will get concatenated again - I hope... :)
