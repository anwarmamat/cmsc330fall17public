require_relative "graph.rb"

class Synsets
    def initialize
    end

    def load(synsets_file)
        f = File.open(synsets_file, "r")
    end

    def addSet(synset_id, nouns)
      if(( synset_id < 0 || nouns.length == 0   )) #or already defined
        @synset_id = synset_id
        @nouns = nouns
    end

    def lookup(synset_id)
        raise Exception, "Not implemented"
    end

    def findSynsets(to_find)
        raise Exception, "Not implemented"
    end
end

class Hypernyms
    def initialize
    end

    def load(hypernyms_file)
        raise Exception, "Not implemented"
    end

    def addHypernym(source, destination)
        raise Exception, "Not implemented"
    end

    def lca(id1, id2)
        raise Exception, "Not implemented"
    end
end

class CommandParser
    def initialize
        @synsets = Synsets.new
        @hypernyms = Hypernyms.new
    end

    def parse(command)
        raise Exception, "Not implemented"
    end
end
