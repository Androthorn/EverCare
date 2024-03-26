module Haskell.Models.Avaliacao where
    
import Data.Time
import Haskell.App.Util (split)

data Avaliacao = Avaliacao
    { idAvaliacao :: Int
    , idPac :: Int
    , idMed :: Int
    , nota :: Int
    , comentario :: String
    }

toString :: Avaliacao -> String
toString m = show (idAvaliacao m) ++ ";" ++
             show (idPac m) ++ ";" ++
             show (idMed m) ++ ";" ++
             show (nota m) ++ ";" ++
             comentario m 

instance Show Avaliacao where
    show (Avaliacao idAvaliacao idPac idMed nota comentario ) = "-------------------\n" ++
                    "ID Avaliacao: " ++ show idAvaliacao ++ "\n" ++
                    "Paciente: " ++ show idPac ++ "\n" ++
                    "Médico: " ++ show idMed ++ "\n" ++
                    "Nota: " ++ show nota ++ "\n" ++
                    "Comentário: " ++ comentario ++ "\n" ++
                    "-------------------\n"
        
instance Read Avaliacao where
    readsPrec _ str = do
        let avaliacao = split str ';' ""
        let idAvaliacao = read (avaliacao !! 0) :: Int
        let idPac = read (avaliacao !! 1) :: Int
        let idMed = read (avaliacao !! 2) :: Int
        let nota = read (avaliacao !! 3) :: Int
        let comentario = avaliacao !! 4
        let dataHora = getCurrentTime -- Get the current time and date
        [(Avaliacao idAvaliacao idPac idMed nota comentario , "")]