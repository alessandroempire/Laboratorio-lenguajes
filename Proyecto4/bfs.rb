# Alessandro La Corte
# Donato Rolo
#


class BinTree
    attr_accessor :value, # Valor almacenado en el nodo
                  :left,  # BinTree izquierdo
                  :right  # BinTree derecho

    def initialize(v,l,r)
        @value = v
        @left  = l 
        @right = r
    end

    def each(b)
        return if self.nil?
        
        yield self.value
        self.left.each(b) if self.left
        self.right.each(b) if self.right
    end
end

class GraphNode
    attr_accessor :value,    # Valor alamacenado en el nodo
                  :children  # Arreglo de sucesores GraphNode
    def initialize(v,c)
        # Su codigo aqui
    end

    def each(b)
        # Su codigo aqui
    end
end
