module Paciente where
import Prelude hiding (id)
import Haskell.View.Utils (split, formataBool)
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
                    "Cardiopata? " ++ formataBool c ++ "\n"++
                    "Hipertenso? " ++ formataBool h ++ "\n" ++
                    "Diabético? " ++ formataBool db

instance Read Paciente where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let nome = l !! 1
        let cpf = l !! 2
        let sexo = l !! 3
        let dataNascimento = l !! 4
        let endereco = l !! 5
        let planoDeSaude = l !! 6
        let tipoSanguineo = l !! 7
        let cardiopata = if (toUpper $ head (l !! 8)) == 'S' then True else False
        let diabetico =  if (toUpper $ head (l !! 9)) == 'S' then True else False
        let hipertenso = if (toUpper $ head (l !! 10)) == 'S' then True else False
        [(Paciente id nome cpf sexo dataNascimento endereco planoDeSaude tipoSanguineo cardiopata diabetico hipertenso, "")]