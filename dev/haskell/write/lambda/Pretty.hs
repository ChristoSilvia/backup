{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Pretty (
  ppexpr
) where

import Syntax

import Text.PrettyPrint

class Pretty p where
  ppr :: Int -> p -> Doc

parensIf :: Bool -> Doc -> Doc
parensIf True = parens
parensIf False = id

instance Pretty Name where
  ppr _ x = text x

viewVars :: Expr -> [Name]
viewVars (Lam n a) = n : viewVars a
viewVars _ = []

viewBody :: Expr -> Expr
viewBody (Lam _ a) = viewBody a
viewBody x = x

viewApp :: Expr -> (Expr, [Expr])
viewApp (App e1 e2) = go e1 [e2]
  where
    go (App a b) xs = go a (b : xs)
    go f xs         = (f, xs)
viewApp _ = error "not application"

instance Pretty Expr where
  ppr _ (Var x)         = text x
  ppr _ (Lit (LInt a))  = text (show a)
  ppr _ (Lit (LBool b)) = text (show b)
  ppr level e@(App _ _) = parensIf (level>0) 
                                   (ppr level f <+> sep (map (ppr (level+1)) xs))
    where (f, xs) = viewApp e
  ppr level e@(Lam _ _) = parensIf (level>0)
                                   (char '\\' <> hsep vars <+>  text "." <+> body)
    where
      vars = map (ppr 0) (viewVars e)
      body = ppr (level+1) (viewBody e)
  

ppexpr :: Expr -> String
ppexpr = render . ppr 0
