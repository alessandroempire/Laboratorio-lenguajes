# Alessandro La Corte
# Donato Rolo

module BFSProcedures

    def alreadyExists(elem)
        self.each do |x|
            if x.last == elem
                return true
            end
        end
    end

    def find(start, predicate)

        if predicate.call(start.value)
            start
        else
            rest = []
            block = lambda{ |son| if son != nil; rest << son; end}
            start.each(block)
            while !rest.empty?
                aux = rest.shift
                if predicate.call(aux.value)
                    return aux
                end
                aux.each(block)
            end
        end
    end

    def path(start, predicate)

        def alreadyExists(lista,elem)
            lista.each do |x|
                if x.last == elem
                    return true
                end
            end
        end

        def getPath(lista,predicate)
            lista.each do |x|
                if predicate.call(x.last)
                    return x
                end
            end
        end

        if predicate.call(start.value)
            
            return [start.value]
        
        else

            open = []
            close = []

            open.push([start.value])

            while !open.empty?

                close << open.shift
                actual = close.last.clone

                block = lambda{|elem| elem == actual.last}

                elem = start.find(start, block)

                block2 = lambda {|suc| 
                    if (suc != nil) && self.alreadyExists(open,suc) && self.alreadyExists(close,suc)

                        aux = actual.clone
                        x = Array.new(aux.push(suc.value))
                        open.push(x)
                    end
                }
                
                elem.each(block2)

            end

            way = getPath(close,predicate)
            return way
        end
    end

    def walk(start, action)

        rest = [start]
        visits = []
        
        block = lambda{ |son| if son != nil; rest << son; end}
        
        while !rest.empty?
            aux = rest.shift
            a = action.call(aux.value)
            visits.push(a)
            aux.each(block)
        end

        return visits
    end

end

# a = BinTree.new(4,nil,nil)
# b = BinTree.new(5,nil,nil)
# c = BinTree.new(6,nil,nil)
# d = BinTree.new(7,nil,nil)

# e = BinTree.new(2,a,b)
# f = BinTree.new(3,c,d)

# g = BinTree.new(1,e,f)




class BinTree

    attr_accessor :value, # Valor almacenado en el nodo
                  :left,  # BinTree izquierdo
                  :right  # BinTree derecho

    include BFSProcedures

    def initialize(v,l,r)
        @value = v
        @left  = l 
        @right = r
    end

    def each(b)
        b.call( self.left ) if self.left
        b.call( self.right )if self.right
    end
end

class GraphNode

    attr_accessor :value,    # Valor alamacenado en el nodo
                  :children  # Arreglo de sucesores GraphNode

    include BFSProcedures

    def initialize(v,c)
        @value = v
        @children = c
    end

    def each(b)
        if self.children
            @children.each do |sucesor|
                b.call(sucesor) if sucesor
            end
        end
    end
end


class LCR
    
    attr_reader :value
    
    include BFSProcedures

    def initialize(?)  # Indique los argumentos

    end

    def each(p)

    end

    def solve
        
    end

end