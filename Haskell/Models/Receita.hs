module Haskell.Models.Receita where


import Haskell.App.Util (split)
import Prelude hiding (id)

data Receita = Receita {
    id :: Int,
    idMedico :: Int,
    idPaciente :: Int,
    texto :: String
}

toString :: Receita -> String
toString r =
    show (id r) ++ ";" ++
    show (idMedico r) ++ ";" ++
    show (idPaciente r) ++ ";" ++
    show (texto r)

instance Show Receita where
    show (Receita id idM idP texto) = "----------------------------\n" ++
                                        "RECEITUÁRIO " ++ (show id) ++ "\n" ++
                                        "Médico responsável: " ++ (show idM) ++ "\n" ++
                                        "Paciente: " ++ (show idP) ++ "\n" ++
                                        "Remédios: " ++ "\n" ++  texto

instance Read Receita where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idMedico = read (l !! 1) :: Int
        let idPaciente = read (l !! 2) :: Int
        let texto = read (l !! 3) :: String
        [(Receita id idPaciente idMedico texto, "")]