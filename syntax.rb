CONJUNCTIONS = ["ut", "cum", "qui", "quae", "quod", ]
VERBS = ["amat", "est", "deduceret", "imperavit", "pascebatur"]
PRED = ["amat", "imperavit"]

class StructureAnalysis
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
    match.nil? ? "" : match[0]
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
    @raw_split = raw_split
  end


  def string
    indent_raw_string_values
    fit_raw_string_values_to_string
    add_satzzeichen
    str
  end

  def indent(level)
    "  " * level
  end
  
  def raw_split
    raw_split = {}
    sentence.split(/\s/).each_with_index { |x,i| raw_split[i] = x }
    raw_split
  end

  def indent_raw_string_values   # Ruby is so crazy...
    structure.each_with_index do |x,i|
      raw_split.each do |k,v|
        if raw_split[k].match(/,/)
          if x.include?(raw_split[k].chop)
            @raw_split[k].prepend(indent(i))
          end
        else
          if x.include?(raw_split[k])
             @raw_split[k].prepend(indent(i))
          end
        end
      end
    end
  end

  def fit_raw_string_values_to_string
    rs = @raw_split
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
#   aufz�hlungs commas should NOT be a problem. they will split the sentence
#   initially, but will get concatenated again - I hope... :)
