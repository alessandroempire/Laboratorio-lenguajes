# Alessandro La Corte
# Donato Rolo

# Juegos de Manos

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

    def initialize(name, strategy)
        @name = name
        @strategy = strategy
    end

    def next(ms)
        @strategy.next(ms)
    end

    def to_s
        puts @name
        puts @strategy.to_s
    end

    def reset
        @strategy.reset
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

    def reset
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

    def reset
    end
end

class Mirror < Strategy
    attr_accessor :mov, :key

    def initialize(mov)
        @mov = mov
        @key = true
    end

    def to_s
        puts "Mirror"
    end

    def next(ms)
        if ms.size == 0 or @key
            @key = false
            @mov
        else
            ms.last
        end
    end

    def reset
        @key = true
    end
end

class Smart < Strategy
    attr_accessor :p, :r, :s

    def initialize
        @p = 0
        @r = 0
        @s = 0
    end

    def to_s
        puts "Smart"
    end

    def next(ms)
        up_count(ms.last) if ms.size != 0
        #puts @p
        #puts @r
        #puts @s
        l = @p + @r + @s - 1
        n = rand(0..l)
        if n == nil
            return Scissors
        end
        if n.between?(0, @p-1)
            return Scissors
        elsif n.between?(0, @p+@r-1)
            return Paper
        else
            return Rock
        end
    end

    def up_count(x)
        if x == Paper
            @p += 1
        elsif x == Rock
            @r += 1
        else
            @s += 1
        end
    end

    def reset
        initialize
    end
end

class Match
    attr_accessor :player1, :list1,
                  :player2, :list2,
                  :scoreboard

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
            start_mov
    end

    def to_s
        @player1.to_s
        @player2.to_s
    end 

    def start_mov
        @list1 = Array.new
        @list2 = Array.new
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
        #puts "ronda"
        m1 = @player1.next(@list2)
        m2 = @player2.next(@list1)
        @list1.push(m1)
        @list2.push(m2)
        #puts m1.to_s
        #puts m2.to_s
        result = m1.score(m2)
        @scoreboard[@player2.name] += result.pop
        @scoreboard[@player1.name] += result.pop
        @scoreboard[:Rounds] += 1
    end

    def restart
        start_mov
        @player1.reset
        @player2.reset
        @scoreboard.each do |key,val|
            @scoreboard[key] = 0
        end
    end  
end
