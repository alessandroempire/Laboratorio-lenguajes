# Alessandro La Corte
# Donato Rolo

module BFSProcedures

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

    def pathaux(start,predicate)

        if predicate.call(start.value)
            
            return [start.value]
        
        else

            open = []
            close0 = []

            open.push([[start.value]])

            i = 0

            while !open.empty?
                puts "#{i}"
                close0 << open.shift
                aux = Array.new(close0.last)

                print aux
                
                block = lambda{|elem| elem == aux.last}

                # find esta retornando nil
                elem = find(start, block)

                puts elem.value
                puts elem.left.value

                block2 = lambda {|elem2| if (elem2 != nil); x = Array.new(aux.push(elem2.value)); open.push(x); end}
                elem.each(block2)
                i = i + 1
            end

            return close0
        end
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
