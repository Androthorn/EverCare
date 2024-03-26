module Haskell.Models.Exame where

    
import Haskell.App.Util (split)
import Prelude hiding (id)

data Exame = Exame {
    id :: Int,
    idPaciente :: Int,
    idMedico :: Int,
    tipo :: String,
    dia :: String
}

--Ajeitar o tipo da data

toString :: Exame -> String
toString e =
    show (id e) ++ ";" ++
    show (idPaciente e) ++ ";" ++
    show (idMedico e) ++ ";" ++
    tipo e ++ ";" ++
    show (dia e)
    

instance Show Exame where
    show (Exame id idP idM t d) = "----------------------------\n" ++
                                        "EXAME " ++ (show id) ++ "\n" ++
                                        "Paciente: " ++ (show idP) ++ "\n" ++
                                        "Médico responsável: " ++ (show idM) ++ "\n" ++
                                        "Tipo do exame: " ++ t ++ "\n" ++
                                        "Data: " ++ (show d) ++ "\n"

instance Read Exame where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idPaciente = read (l !! 1) :: Int
        let idMedico = read (l !! 2) :: Int
        let tipo = l !! 3
        let dia = read (l !! 4) :: String
        [(Exame id idPaciente idMedico tipo dia, "")]