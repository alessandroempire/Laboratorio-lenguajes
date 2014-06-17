=begin
 Alessandro La Corte
 Donato Rolo

 Juegos de Manos

=end


# Clase Movement
# Se inicializa con el Movimiento deseado, Ej. Movement.new(Rock)

class Movement
    attr_reader :name

    def initialize(ini)
        @name = ini 
    end

    def to_s
        @name.to_s
    end

    def score(m)
        @name.score(m)
    end
end

class Rock < Movement
    def self.score(m)
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
    def self.score(m)
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
    def self.score(m)
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

# Clase Strategy
# name sera un String. strategy sera el nombre de la estrategia a usar. 
# my_mov sera una lista, que lleva los movimientos del juegador
# se necestia una lista para los movimientos del contricante. ms?
# puedo usar push y pop....

class Strategy
    attr_reader :name, :strategy
    attr_accessor :my_mov

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
end

class Uniform < Strategy
    attr_accessor :list

    def initialize(ms)
        raise "Lista de movimientos de Uniform vacio" if ms.size == 0
        @list = ms & ms
    end

    def next
        p   = @list.size
        n   = rand(1..p) - 1
        mov = @list[n]
        cl  = eval(mov.to_s)
    end
end

class Biased < Strategy
    attr_accessor :map, :total

    def initialize(ma)
        raise "Map de movimientos en Biased vacio" if ma.length == 0
        #hash elimina dulicados por si solo...
        @map = Hash.new
        @map.replace(ma)
        @total = 0
        ma.each do |key, val|
            @total += val
        end
    end

    def next
        n = rand(1..@total)
        puts n
        x = 0
        @map.each do |key,val|
            puts x
            if n.between?(x+1,val + x)
                return eval(key.to_s)
            else
                x += val
            end
        end
    end
end

class Mirror < Strategy
    attr_accessor :list_o, :mov

    def initialize(mov)
        @mov = mov
    end

end

class Smart < Strategy
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
