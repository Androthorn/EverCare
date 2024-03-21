module Haskell.Models.Paciente where
    
import Haskell.App.Util (boolToString, split)

import Prelude hiding (id)
import Data.Char (toUpper)

data Paciente = Paciente {
    id :: Int,
    nome :: String,
    cpf :: String,
    dataDeNascimento :: String,
    sexo :: String,
    endereco :: String,
    planoDeSaude :: String,
    tipoSanguineo :: String,
    cardiopata :: Bool,
    hipertenso :: Bool,
    diabetico :: Bool
}

toString :: Paciente -> String
toString p = show (id p) ++ ";" ++
             nome p ++ ";" ++
             cpf p ++ ";" ++
             dataDeNascimento p ++ ";" ++
             sexo p ++ ";" ++
             endereco p ++ ";" ++
             planoDeSaude p ++ ";" ++
             tipoSanguineo p ++ ";" ++
             show (cardiopata p) ++ ";" ++
             show (hipertenso p) ++ ";" ++
             show (diabetico p)


instance Show Paciente where
    show (Paciente id n cpf dtn s e ps ts c h db) = "-------------------\n" ++
                    "Id do Paciente: " ++ (show id) ++ "\n" ++
                    "Nome Completo: " ++ n ++ "\n" ++
                    "Cpf: " ++ cpf ++ "\n" ++
                    "Sexo: " ++ s ++ "\n" ++
                    "Data de nascimento: " ++ dtn ++ "\n" ++
                    "Endereço: " ++ e ++ "\n" ++
                    "Tipo sanguíneo: " ++ ts ++ "\n" ++
                    "Cardiopata? " ++ boolToString c ++ "\n"++
                    "Hipertenso? " ++ boolToString h ++ "\n" ++
                    "Diabético? " ++ boolToString db

instance Read Paciente where
    readsPrec _ str = do
        let paciente = split str ';' ""
        let id = read (paciente !! 0) :: Int
        let nome = paciente !! 1
        let cpf = paciente !! 2
        let sexo = paciente !! 3
        let dataNascimento = paciente !! 4
        let endereco = paciente !! 5
        let planoDeSaude = paciente !! 6
        let tipoSanguineo = paciente !! 7
        let cardiopata = if (toUpper $ head (paciente !! 8)) == 'S' then True else False
        let diabetico =  if (toUpper $ head (paciente !! 9)) == 'S' then True else False
        let hipertenso = if (toUpper $ head (paciente !! 10)) == 'S' then True else False
        [(Paciente id nome cpf sexo dataNascimento endereco planoDeSaude tipoSanguineo cardiopata diabetico hipertenso, "")]