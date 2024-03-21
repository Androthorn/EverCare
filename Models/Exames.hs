module Haskell.Model.Exame where
import App.Utils
import Prelude hiding (id)
import Data.Dates

data Exame = Exame {
    id :: Int,
    idPaciente :: Int,
    idMedico :: Int,
    tipo :: String,
    dia :: DateTime,
    resultado :: String
}

--Ajeitar o tipo da data

toString :: Exame -> String
toString e =
    show (id e) ++ ";" ++
    show (idPaciente e) ++ ";" ++
    show (idMedico e) ++ ";" ++
    show (idUBS e) ++ ";" ++
    tipo e ++ ";" ++
    resultado e ++ ";" ++
    dateTimeToString (dia e)
    

instance Show Exame where
    show (Exame id idP idM t d ) = "----------------------------\n" ++
                                        "EXAME " ++ (show id) ++ "\n" ++
                                        "Paciente: " ++ (show idP) ++ "\n" ++
                                        "Médico responsável: " ++ (show idM) ++ "\n" ++
                                        "Tipo do exame: " ++ t ++ "\n" ++
                                        "Data: " ++ (dateTimeToString d) ++ "\n"

instance Read Exame where
    readsPrec _ str = do
    let l = split str ';' ""
    let id = read (l !! 0) :: Int
    let idPaciente = read (l !! 1) :: Int
    let idMedico = read (l !! 2) :: Int
    let tipo = l !! 3
    let dia = read (l !! 4) :: DateTime
    [(Exame id idPaciente idMedico tipo dia, "")]