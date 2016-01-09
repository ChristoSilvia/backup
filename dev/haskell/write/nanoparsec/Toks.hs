

type Name = String

data Expr 
  = Var Name
  | App Expr Expr
  | Lam Name Expr
  | Lit Lit

data Lit
  = LInt Int
  | LBool Bool


parensIf :: Bool -> Doc -> Doc
parensIf True = parens
parensIf False = id

viewVars :: Expr -> [Name]
viewVars (Lam n a) = n : viewVars a
viewVars _ = []

viewBody :: Expr -> Expr
viewBody (Lam _ a) = viewBody a
viewBody x = x

instance Pretty Expr where
  ppr p e = case e of
    Lit (LInt a)  -> text (show a)
    Lit (LBool b) -> text (show b)
    Var x   -> text x
    App a b -> parensIf (p>0) $ (ppr (p+1) a) <+> (ppr p b)
    Lam x a -> parensIf (p>0) $
         char '\\'
      <> hsep (fmap pp (viewVars e))
      <+> "->"
      <+> ppr (p+1) (viewBody e)

ppexpr :: Expr -> String
ppexpr = render . ppr 0
    
