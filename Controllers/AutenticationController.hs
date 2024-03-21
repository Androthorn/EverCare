module Controllers.AutenticationController (
    autenticaPaciente
) where

import qualified Models.DataBase as BD

autenticaPaciente :: [(Int, String)] -> Int -> String -> Bool
autenticaPaciente ((u, s):xs) user senha       | u == user && s == senha = True
                                               | otherwise = autenticaPaciente xs user senha
autenticaPaciente [] _ _ = False