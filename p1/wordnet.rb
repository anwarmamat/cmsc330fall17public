require_relative 'graph.rb'

class Synsets
  def initialize
    @syn = {}
  end

  def load(synsets_file)
    synTemp = {}
    File.open(synsets_file, 'r') do |f|
      i = 1 # test multiple runs
      trigger = false
      f.each_line do
        if f.match(/(id: )(\d+)\s(synset: )(\S+)/) && !(synTemp.key?(Regexp.last_match(2)) || syn.key(Regexp.last_match(2)))
          # split into stuff after id
          # split into avlues, seperated by ,
          synValDirty = Regexp.last_match(4) # with commas
          synVal = synValDirty.split(',')
          synTemp[Regexp.last_match(2)] = synVal
          i += 1
        else
          trigger = true
          badLines[].push(i)
          i += 1
        end
      end
      if trigger
        return badLines
      else
        @syn = synTemp
        nil
      end
    end
  end
end

def addSet(synset_id, nouns)
  if synset_id < 0 || nouns.empty? # or already defined
    @synset_id = synset_id
    @nouns = nouns
  end
end

  def lookup(_synset_id)
    raise Exception, 'Not implemented'
  end

  def findSynsets(_to_find)
    raise Exception, 'Not implemented'
  end


class Hypernyms
  def initialize; end

  def load(_hypernyms_file)
    raise Exception, 'Not implemented'
  end

  def addHypernym(_source, _destination)
    raise Exception, 'Not implemented'
  end

  def lca(_id1, _id2)
    raise Exception, 'Not implemented'
  end
end

class CommandParser
  def initialize
    @synsets = Synsets.new
    @hypernyms = Hypernyms.new
  end

  def parse(_command)
    raise Exception, 'Not implemented'
  end
end
