module Haskell.Controllers.AutenticationController (
    autentica
) where

import qualified Haskell.Models.BD as BD

autentica :: [(Int, String)] -> Int -> String -> Bool
autentica ((u, s):xs) user senha       | u == user && s == senha = True
                                               | otherwise = autentica xs user senha
autentica [] _ _ = False