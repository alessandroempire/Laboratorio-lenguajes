module Polinomios where

import Ratio

instance Num a => Num [a] where
  fromInteger c = [fromInteger c]
  negate [] = []
  negate (f:fs) = (negate f) : (negate fs)
  fs     + []     = fs
  []     + gs     = gs
  (f:fs) + (g:gs) = f+g : fs+gs
  fs     * []     = []
  []     * gs     = []
  (f:fs) * (g:gs) = f*g : (f .* gs + fs * (g:gs))
  abs = id
  signum = id

infixl 7 .*
(.*) :: Num a => a -> [a] -> [a]
c .* []     = []
c .* (f:fs) = c*f : c .* fs

z :: Num a => [a]
z = [0,1]

derivada :: Num a => [a] -> [a]
derivada []     = []
derivada (f:fs) = derivada' fs 1
  where
    derivada' []     _ = []
    derivada' (g:gs) n = n*g : derivada' gs (n+1)

composicion :: Num a => [a] -> [a] -> [a]
composicion _ [] = error "imposible calcular composicion"
composicion [] _ = []
composicion (f:fs) gs = [f] + (gs * composicion fs gs)

instance Fractional a => Fractional [a] where
  fromRational c = [fromRational c]
  fs     / []     = error "divison por cero"
  []     / gs     = []
  (0:fs) / (0:gs) = fs / gs
  (_:fs) / (0:gs) = error "division por cero"
  (f:fs) / (g:gs) = let q = f/g in q : (fs - q .* gs) / (g:gs)
    
integral :: Fractional a => [a] -> [a]
integral fs = 0 : integral' fs 1
  where
    integral' []     _ = []
    integral' (g:gs) n = g/n : integral' gs (n+1)

-- La serie de Fibonacci más complicada de la historia

fibs = tail $ z / (1 - z - z^2)
