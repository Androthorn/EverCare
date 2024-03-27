module Haskell.Models.Chat (
    Chat (..),
    toString
)

where 

import Haskell.App.Util (split)
import Prelude hiding (id)
import Data.List (intercalate)

data Chat = Chat {
    id :: Int,
    idPaciente :: Int,
    idMedico :: Int,
    mensagens :: [String]
}


toString :: Chat -> String
toString c =
    show (id c) ++ ";" ++
    show (idPaciente c) ++ ";" ++
    show (idMedico c) ++ ";" ++
    (intercalate "/" (mensagens c))

instance Show Chat where
    show (Chat id idP idM m) = "----------------------------\n" ++
                                    "CHAT " ++ (show id) ++ "\n" ++
                                    "Paciente: " ++ (show idP) ++ "\n" ++
                                    "Médico: " ++ (show idM) ++ "\n" ++
                                    "Mensagens: " ++ (show m) ++ "\n"

instance Read Chat where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idPaciente = read (l !! 1) :: Int
        let idMedico = read (l !! 2) :: Int
        let mensagens = split (l !! 3) ',' ""
        [(Chat id idPaciente idMedico mensagens, "")]