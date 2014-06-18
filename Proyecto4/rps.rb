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
        @my_mov = Array.new
    end

    def next(ms)
        mov = @strategy.next(ms)
        @my_mov.push(mov)
        mov
    end

    def to_s
        puts @name
        puts @strategy.to_s
    end

    def reset
        @my_mov = Array.new
    end
end

class Uniform < Strategy
    attr_accessor :list

    def initialize(ms)
        raise "Lista de movimientos de Uniform vacio" if ms.size == 0
        @list = ms & ms
    end

    def to_s
        puts "Uniform"
        @list
    end

    def next(*a)
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
        @map = Hash.new
        @map.replace(ma)
        @total = 0
        ma.each do |key, val|
            @total += val
        end
    end

    def to_s
        puts "Biased"
        @map
    end

    def next(*a)
        n = rand(1..@total)
        x = 0
        @map.each do |key,val|
            if n.between?(x+1,val + x)
                return eval(key.to_s)
            else
                x += val
            end
        end
    end
end

class Mirror < Strategy
    attr_accessor :mov

    def initialize(mov)
        @mov = mov
    end

    def to_s
        puts "Mirror"
    end

    def next(ms)
        if ms.size == 0
            @mov
        else
            ms.last
        end
    end

end

class Smart < Strategy
    def initialize
    end

    def to_s
    end

    def next
    end
end

class Match
    attr_accessor :player1, :player2, :scoreboard

    def initialize(m)
        aux = Array.new
        @scoreboard = Hash.new
        m.each do |key,val|
            a = Strategy.new(key, val)
            aux.push(a)
            @scoreboard[key] = 0 
        end
        @player2 = aux.pop
        @player1 = aux.pop
        @scoreboard[:Rounds] = 0
    end

    def to_s
        @player1.to_s
        @player2.to_s
    end 

    def rounds(n)
        until n == 0
            play
            n -= 1
        end
        @scoreboard
    end

    def upto(n)
        while true 
            break if @scoreboard[@player2.name] == n 
            break if @scoreboard[@player1.name] == n
            play
        end
        @scoreboard
    end

    def play
        puts "ronda"
        last1 = Array.new
        last2 = Array.new
        last1.replace(@player1.my_mov)
        last2.replace(@player2.my_mov)
        #puts last1.to_s
        #puts last2.to_s
        m1 = @player1.next(last2)
        m2 = @player2.next(last1)
        puts m1.to_s
        puts m2.to_s
        result = m1.score(m2)
        @scoreboard[@player2.name] += result.pop
        @scoreboard[@player1.name] += result.pop
        @scoreboard[:Rounds] += 1
    end

    def restart
        @scoreboard.each do |key,val|
            @scoreboard[key] = 0
        end
        #restart de cada player
    end  
end
