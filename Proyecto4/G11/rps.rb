# Alessandro La Corte
# Donato Rolo

# Juegos de Manos

# Clase Movement
# Clase genérica de movimientos posibles. Provee métodos de to_s para 
# convertirlo a string y score para obtener la puntuación. 
# Se crean 3 subclases de Movement: Rock, Paper, Scissors.
# En cada subclase se emplea la técnica de despacho múltiple para encontrar
# la respectiva puntuación de un movimiento.

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
# name será un string con el nombre de la estrategia
# strategy será una instancia de alguna de las estrategias. 
# Se declara el seed = 42 la función random. 
# Los métodos de Strategy llaman a los métodos de las instancias en @strategy.

class Strategy
    @@seed = 42
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

# Clase Uniform
# Cada Movement tiene la misma probabilidad de ser elegido
# Para escogerlo se emplea la función random. 

class Uniform < Strategy
    attr_accessor :list, :r

    def initialize(ms)
        raise "Lista de movimientos de Uniform vacio" if ms.size == 0
        @list = ms & ms
        @r = Random.new(@@seed)
    end

    def to_s
        puts "Uniform"
        @list
    end

    def next(*a)
        p   = @list.size
        n   = @r.rand p
        mov = @list[n]
        cl  = eval(mov.to_s)
    end

    def reset
    end
end

# Clase Biased
# Cada Movement tiene una probabilidad sesgada. 
# Se analiza el rango del número random para escoger el siguiente Movement. 
# Ejemplo: a = 1/6, b = 3/6, c = 2/6
# Sí el numero random es 1, se elige a; sí está entre 2 y 4 se elige b;
# sí está entre 5 y 6 se elige c.

class Biased < Strategy
    attr_accessor :map, :total, :r

    def initialize(ma)
        raise "Map de movimientos en Biased vacio" if ma.length == 0
        @map = Hash.new
        @map.replace(ma)
        @total = 0
        ma.each do |key, val|
            @total += val
        end
        @r = Random.new(@@seed)
    end

    def to_s
        puts "Biased"
        @map
    end

    def next(*a)
        n  = @r.rand @total
        n += 1
        x = map.values[0]
        @map.each do |key,val|
            if n.between?(x,(val-1) + x)
                return eval(key.to_s)
            else
                x += val
            end
        end
    end

    def reset
    end
end

# Clase Mirror
# Para elegir un Movement, se elige el caso base cuando se comienza el juego o 
# reinicia la estrategia, sino se escoge el último movimiento del contrincante.

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

# Clase Smart
# Para elegir un Movement, se cuenta la cantidad de ocurrencias de cada Movement
# que ha realizado el contricante, y se escoge uno tal que le gane al
# Movement que más ha usado el contrincante.

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

# Clase Match
# se tiene la información de cada jugador: player1 y player2
# se tiene la lista de los movimientos realizado por cada jugador: list1 y list2
# se tiene el scoreboard que lleva el puntaje de la partida. 

class Match
    attr_accessor :player1, :list1,
                  :player2, :list2,
                  :scoreboard

    def initialize(m)
        raise "Numero de jugadores incorrecto" if m.length != 2 
        aux = Array.new
        @scoreboard = Hash.new
        m.each do |key,val|
            raise "No son estrategias." unless val.kind_of? Strategy
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
        m1 = @player1.next(@list2)
        m2 = @player2.next(@list1)
        @list1.push(m1)
        @list2.push(m2)
        result = m1.score(m2)
        @scoreboard[@player2.name] += result.pop
        @scoreboard[@player1.name] += result.pop
        @scoreboard[:Rounds] += 1
    end

    def reset
        @player1.reset
        @player2.reset
    end

    def restart
        start_mov
        reset
        @scoreboard.each do |key,val|
            @scoreboard[key] = 0
        end
    end  
end
