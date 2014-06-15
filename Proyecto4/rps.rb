=begin
 Alessandro La Corte
 Donato Rolo

 Juegos de Manos

=end


#Clase

class Movement
    attr_reader :name

    def initialize(ini="Movement")
        @name = ini 
    end

    def to_s
        name
    end
end

class Rock < Movement
    attr_reader :name

    def initialize (ini="Rock")
        @name = ini
    end

    def score(m)
        m.score_rock
    end

    def self.score_rock
        [0,0]
    end

    def self.score_paper
        [1,0]
    end 

    def self.score_scissors
        [0,1]
    end
end

class Paper < Movement
    attr_reader :name

    def initialize (ini="Paper")
        @name = ini
    end

    def score(m)
        m.score_paper
    end

    def self.score_rock
        [0,1]
    end

    def self.score_paper
        [0,0]
    end 

    def self.score_scissors
        [1,0]
    end
end

class Scissors < Movement
    attr_reader :name

    def initialize (ini="Scissors")
        @name = ini
    end

    def score(m)
        m.score_scissors
    end

    def self.score_rock
        [1,0]
    end

    def self.score_paper
        [0,1]
    end 

    def self.score_scissors
        [0,0]
    end
end


class Strategy
end
