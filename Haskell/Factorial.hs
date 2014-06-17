fact n = dale 1 n
        where dale f 1 = f
              dale f x = dale (f*x) (x-1)
