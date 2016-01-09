module Numeral = 
  struct
    type numeral = I | V | X | L | C | D | M
    type roman = numeral list

    let rec int_of_roman (r:roman) : int =
      match r with
        I::V::rs -> 4 + (int_of_roman rs)
        I::X::rs -> 9 + (int_of_roman rs)
        X::L::rs -> 40 + (int_of_roman rs)
        X::C::rs -> 90 + (int_of_roman rs)
        C::D::rs -> 400 + (int_of_roman rs)
        C::M::rs -> 900 + (int_of_roman rs)
        I::rs -> 1 + (int_of_roman rs)
        V::rs -> 5 + (int_of_roman rs)
        X::rs -> 10 + (int_of_roman rs)
        L::rs -> 50 + (int_of_roman rs)
        C::rs -> 100 + (int_of_roman rs)
        D::rs -> 500 + (int_of_roman rs)
        M::rs -> 1000 + (int_of_roman rs)
        []    -> 0
