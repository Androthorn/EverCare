module Haskell.Controllers.AutenticationController (
    autentica,
    autenticaPaciente,
    autenticaClinica
) where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Clinica as Clinica

autentica :: [(Int, String)] -> Int -> String -> Bool
autentica ((u, s):xs) user senha       | u == user && s == senha = True
                                               | otherwise = autentica xs user senha
autentica [] _ _ = False

-- | Função que verifica se o login é válido
autenticaPaciente :: [Paciente.Paciente] -> Int -> String -> Bool
autenticaPaciente [] _ _ = False  -- Base case for an empty list
autenticaPaciente (x:xs) user senha =
    if (Paciente.id x) == user && (Paciente.senha x) == senha
        then True
        else autenticaPaciente xs user senha

autenticaClinica :: [Clinica.Clinica] -> Int -> String -> Bool
autenticaClinica [] _ _ = False  -- Base case for an empty list
autenticaClinica (x:xs) user senha =
    if (Clinica.id x) == user && (Clinica.senha x) == senha
        then True
        else autenticaClinica xs user senha
