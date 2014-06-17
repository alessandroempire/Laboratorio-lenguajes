# Números racionales -- fracciones
# Ya Ruby tiene Rational, pero soy flojo.
# Atributos: numerador y denominador.
# Invariante: mantiene las fracciones normalizadas / denominador > 0.
class Racional
  
  attr_reader :num, :den

  def initialize(num,den=1)
    if den == 0
      raise "Racional con denominador inadecuado"
    elsif den < 0
      @num = -num
      @den = -den
    else
      @num = num
      @den = den
    end
    reduce
  end

  # To String -- always a good idea
  def to_s
    ans = @num.to_s
    if @den != 1
      ans += "/"
      ans += @den.to_s
    end
    ans
  end

  # Mutates!
  def add! r
    n1 = r.num
    d1 = r.den
    n2 = @num
    d2 = @den
    @num = (n1 * d2) + (n2 * d1)
    @den = d1 * d2
    reduce
    self
  end

  # a+b sugar for a.+(b) -- Doesn't mutate.
  def + r
    ans = Racional.new(@num,@den)
    ans.add! r
  end

  protected

  def reduce
    if @num == 0
      @den == 1
    else
      d = mcd(@num.abs,@den)
      @num = @num / d
      @den = @den / d
    end
  end

  def mcd(x,y)
    if x == y
      x
    elsif x < y
      mcd(x,y-x)
    else
      mcd(x-y,y)
    end
  end

end
