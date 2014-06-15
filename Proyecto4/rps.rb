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
    attr_reader :name, :strategy
    attr_accessor :list

    def initialize(name, strategy)
        @name = name
        @strategy = strategy
    end

    def next(ms)
    end

    def to_s
    end

    def reset
    end

    def Uniform
    end

    def Biased
    end

    def Mirror
    end

    def Smart
    end

end

class Match
    attr_accessor :info, :score

    def initialize(m)
        @info = Hash.new
        @info.replace(m)
        self.start_score
    end

    def start_score
        @score = Hash.new
        @info.each do |key, val|
            @score[key] = 0    
        end
        @score[:Rounds] = 0
    end

    def to_s
        @info.to_s
    end 

    def rounds(n)
        until n == 0
            @score[:Rounds] += 1
            puts @score
            n -= 1
        end
    end

    def upto(n)
        while true 
            n += 1
            puts n
            break if n > 5
        end
    end

    def restart
        start_score
    end
    
end
