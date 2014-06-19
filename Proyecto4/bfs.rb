# Alessandro La Corte
# Donato Rolo

module BFSProcedures

    # def find(start,predicate)
    #     if start
    #         puts start.value
    #         if predicate.call(start.value)
    #             return start
    #         else
    #             sons = []
    #             block = lambda{ |son| sons << son}
    #             start.each(block)
    #             while !sons.empty?
    #                 newstart = sons.shift
    #                 find(newstart, predicate)    
    #             end
    #         end 
    #     end
    # end

    def find(start, predicate)

        if predicate.call(start.value)
            start
        else
            rest = []
            block = lambda{ |son| rest << son}
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

    def pathaux(start,predicate,arreglo)

        if predicate.call(start.value)
            return arreglo << start.value
        else
            rest = []
            block = lambda{ |son| rest << son}
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


end

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
