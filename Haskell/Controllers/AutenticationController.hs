module Haskell.Controllers.AutenticationController (
    autentica,
    autenticaPaciente,
    autenticaClinica,
    autenticaMedico
) where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico

autentica :: [(Int, String)] -> Int -> String -> Bool
autentica [] _ _ = False
autentica ((u, s):xs) user senha
    | u == user && s == senha = True
    | otherwise = autentica xs user senha

-- | Função que verifica se o login é válido
autenticaPaciente :: [Paciente.Paciente] -> Int -> String -> Bool
autenticaPaciente [] _ _ = False
autenticaPaciente (x:xs) user senha =
    if (Paciente.id x) == user && (Paciente.senha x) == senha
        then True
        else autenticaPaciente xs user senha

autenticaClinica :: [Clinica.Clinica] -> Int -> String -> Bool
autenticaClinica [] _ _ = False
autenticaClinica (x:xs) user senha =
    if (Clinica.id x) == user && (Clinica.senha x) == senha
        then True
        else autenticaClinica xs user senha

autenticaMedico :: [Medico.Medico] -> Int -> String -> Bool
autenticaMedico [] _ _ = False
autenticaMedico (x:xs) user senha =
    if (Medico.id x) == user && (Medico.senha x) == senha
        then True
        else autenticaMedico xs user senha