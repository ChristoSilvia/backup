type numeral = I | V | X | L | C | D | M
type roman = numeral list

let rec int_of_roman (rs : roman) : int =
  match rs with
  | I::V::rs -> 4 + int_of_roman rs
  | I::X::rs -> 9 + int_of_roman rs
  | X::L::rs -> 40 + int_of_roman rs
  | X::C::rs -> 90 + int_of_roman rs
  | C::D::rs -> 400 + int_of_roman rs
  | C::M::rs -> 900 + int_of_roman rs
  | I::rs -> 1 + int_of_roman rs
  | V::rs -> 5 + int_of_roman rs
  | X::rs -> 10 + int_of_roman rs
  | L::rs -> 50 + int_of_roman rs
  | C::rs -> 100 + int_of_roman rs
  | D::rs -> 500 + int_of_roman rs
  | M::rs -> 1000 + int_of_roman rs
  | []    -> 0

let rec list_of_string = function
  | "" -> []
  | s -> (String.get s 0)::list_of_string (String.sub s 1 ((String.length s) - 1))

let rec string_of_list = function
  | [] -> ""
  | cl -> (Char.escaped (List.hd cl)) ^ (string_of_list (List.tl cl))

let rec list_reverse (pp : 'a list) (nn : 'a list ) : 'a list =
  match nn with
  | [] -> pp
  | n::ns -> list_reverse (n::pp) ns

let string_rev ss = string_of_list (list_reverse [] (list_of_string ss))

let rec contains (ll : 'a list) (el : 'a) : bool =
  match ll with
  | [] -> false
  | l::ls -> if l = el then true else contains ls el


let rec unique (already : 'a list) (args : 'a list) : 'a list =
  match args with
  | [] -> []
  | b::bs -> if contains already b then unique already bs else b :: (unique (b::already) bs)

let rec subsets (pl : 'a list) (cl : 'a list) : 'a list list =
  match cl with
  | [] -> [[]]
  | c::cs  -> List.fold_left List.append [] [ [(c::cs)] ; 
                                              (subsets (c::pl) cs) ;
                                              (subsets [] (List.append pl cs)) ]

let subset a = unique [] (subsets [] a)
