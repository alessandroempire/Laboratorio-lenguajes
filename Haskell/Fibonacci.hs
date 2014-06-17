fib 1 = 1
fib 2 = 1
fib n = fib(n-1) +fib(n-2)

fibt n = dale 1 (0,1)
        where dale x (f1,f2) = if x == n then f2
                               else dale (x+1) (f2, f1+f2)
