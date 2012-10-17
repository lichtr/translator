CONJUNCTIONS = ["ut", "cum", "qui", "quae", "quod", "quamdiu", "quam" ]
VERBS = ["amat", "est", "deduceret", "imperavit", "pascebatur", "procreavit", "transportavit", "esset", "consecraverat"]
PRED = ["amat", "imperavit", "procreavit", "transportavit", "erat"]


class Words

end

class Syntax

end

class StructureAnalysis
  attr_reader :input, :has_verb, :has_conj, :has_pred

  def initialize input
    @input = input
  end

  def sentence
    input[-1].match(/[\.\?!]/) ? input.chop : input
  end

  def end_of_input
    match = input[-1].match(/[\.\?!]/)
    match.nil? ? "" : match[0]
  end

  def structure
    structured = []
    tbo = sentence.split(/,/)     # performance question
    tbo.each { |x| x.strip! }
    tbo = tbo.map { |x| x.split(/\s/) }

    hash = Hash.new
    tbo.each_with_index { |x, i| hash[i] = [x] }

    unless hash.empty?
      hash.each do |k,v|
        satzart(v) 
        case
        when !has_verb && !has_conj
          structured.empty? ? structured << v[0] : structured[0].concat(v[0]) # appositionen und aufzählen sind bitches 
        when has_pred
          structured.empty? ? structured << v[0] : structured[0].concat(v[0])
        when has_verb && has_conj
          structured << v[0]
        when !has_verb && has_conj # && !has_pred don't know why that was important...
          hash.each do |x,y|
            satzart(y)
            if has_verb && !has_conj # && !has_pred we'll see...
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

  def satzart(satzteil)
    @has_verb = !(satzteil[0] & VERBS).empty?
    @has_conj = !(satzteil[0] & CONJUNCTIONS).empty?
    @has_pred = !(satzteil[0] & PRED).empty? 
  end

  def print
    puts StructurePrinter.new(sentence, end_of_input, structure).string
    puts
  end
end

class StructurePrinter
  attr_reader :sentence, :end_of_input, :structure, :raw_split, :str

  def initialize sentence, end_of_input, structure
    @sentence = sentence
    @end_of_input = end_of_input
    @structure = structure
    @raw_split = split_sentence_to_hash 
  end


  def string  # only "public" method here...
    indent_raw_string_values
    fit_raw_string_values_to_string
    add_satzzeichen
    str
  end

  def indent(level)
    "  " * level
  end
  
  def split_sentence_to_hash
    rs = {}
    sentence.split(/\s/).each_with_index { |x,i| rs[i] = x }
    rs
  end

  def indent_raw_string_values 
    structure.each_with_index do |x,i|   
      raw_split.each do |k,v|
        if raw_split[k].match(/,/)
          raw_split[k].prepend(indent(i)) if x.include?(raw_split[k].chop)
        else
          raw_split[k].prepend(indent(i)) if x.include?(raw_split[k])
        end
      end
    end
  end

  def fit_raw_string_values_to_string
    rs = raw_split
    @str = rs[0]

    rs.each do |k,v|
      if rs[k].index(/\S/) == rs[k-1].index(/\S/)
        str << " " + rs[k].strip
      else str << "\n" + rs[k]
      end unless rs[k] == rs[0]
    end
  end

  def add_satzzeichen
    str << end_of_input
  end
end


if __FILE__ == $PROGRAM_NAME

  test = StructureAnalysis.new("Gaius Iuliam amat, quae puella est.")
  test.print

  test = StructureAnalysis.new("Gaius Iuliam, quae puella est, amat.")
  test.print

  test = StructureAnalysis.new("Gaius Iuliam, filiam Claudiae, amat, quod puella pulchra est.")
  test.print

  test = StructureAnalysis.new("Inter quas magna discordia orta Iuppiter imperavit Mercurio, ut deas ad Alexandrum Paridem, qui in Ida monte gregem pascebatur, deduceret.")
  test.print
  p test.structure
  puts

  test = StructureAnalysis.new("hanc Iuppiter, quae est, in taurum conversus a Sidone Cretam transportavit et ex ea procreavit Minoem, Sarpedonem, Rhadamanthum.")
  test.print

  test = StructureAnalysis.new("Aeetae, Solis filio, erat responsum tam diu eum regnum habiturum, quamdiu ea pellis, quam Phrixus consecraverat, in fano Martis esset.")
  test.print
  p test.structure
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
