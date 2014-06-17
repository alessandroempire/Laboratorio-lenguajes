class A
  def foo
    @foo
  end
  def foo= x
    @foo = x
  end
end

class B
  attr_accessor :bar, :baz
  attr_reader :solosepuedeleer

  def initialize(valor_inicial=0)
    @solosepuedeleer = valor_inicial
  end
end
