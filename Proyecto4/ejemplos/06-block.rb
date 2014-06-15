def silly(a)
  if block_given? then
    (yield 4) + (yield 42)
  else
    raise "No blocks given!"
  end
end
