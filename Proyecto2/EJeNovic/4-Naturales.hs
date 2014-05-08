module Naturales where

import Ratio

data Natural = Z | S Natural
     deriving (Eq,Show)

foldn :: (a -> a) -> a -> Natural -> a
foldn f b Z     = b
foldn f b (S n) = f (foldn f b n)

instance Ord Natural where
  compare Z Z         = EQ
  compare Z _         = LT
  compare _ Z         = GT
  compare (S n) (S m) = compare n m

instance Enum Natural where
  succ n         = S n
  pred Z         = Z
  pred (S n)     = n
  toEnum n
    | n < 0      = error "Los Naturales no son negativos!"
    | n == 0     = Z
    | otherwise  = S (toEnum (n-1))
  fromEnum Z     = 0
  fromEnum (S n) = 1 + fromEnum n
  enumFrom n     = map toEnum [(fromEnum n)..]

instance Num Natural where
  (+) = foldn succ
  (*) = \m -> foldn (+m) Z
  (-) = foldn pred
  abs = id
  signum Z = Z
  signum n = (S Z)
  fromInteger n 
    | n < 0     = error "Los Naturales no son negativos!"
    | n == 0    = Z
    | otherwise = S (fromInteger (n-1))

instance Real Natural where
  toRational n = toInteger n % 1

instance Integral Natural where
  quotRem n d
    | d > n     = (Z,n)
    | otherwise = (S q, r)
    where (q,r) = quotRem (n-d) d
  toInteger = foldn succ 0

binary :: Integral a => a -> [Integer]
binary x = reverse $ bits x
  where bits 0 = [0]
        bits 1 = [1]
        bits n = toInteger (rem n 2) : bits (quot n 2)

