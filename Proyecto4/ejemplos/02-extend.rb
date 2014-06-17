class Fixnum
  def fact
    if self == 0 then
      1
    else
      self * (self-1).fact
    end
  end

  def fib
    if self == 0 || self == 1 then
      1
    else
      (self-1).fib + (self-2).fib
    end
  end

  def succ
    puts "WAT?"
  end
end
