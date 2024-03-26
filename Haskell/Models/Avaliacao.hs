module Haskell.Models.Avaliacao where
    
import Data.Time
import Haskell.App.Util (split)

data Avaliacao = Avaliacao
    { idAvaliacao :: Int
    , pacienteId :: Int
    , medicoId :: Int
    , nota :: Int
    , comentario :: String
    }

toString :: Avaliacao -> String
toString m = show (idAvaliacao m) ++ ";" ++
             show (pacienteId m) ++ ";" ++
             show (medicoId m) ++ ";" ++
             show (nota m) ++ ";" ++
             comentario m 

instance Show Avaliacao where
    show (Avaliacao idAvaliacao pacienteId medicoId nota comentario) = "-------------------\n" ++
                    "ID Avaliacao: " ++ show idAvaliacao ++ "\n" ++
                    "Paciente: " ++ show pacienteId ++ "\n" ++
                    "Médico: " ++ show medicoId ++ "\n" ++
                    "Nota: " ++ show nota ++ "\n" ++
                    "Comentário: " ++ comentario ++ "\n" ++
                    "-------------------\n"
        
instance Read Avaliacao where
    readsPrec _ str = do
        let avaliacao = split str ';' ""
        let idAvaliacao = read (avaliacao !! 0) :: Int
        let pacienteId = read (avaliacao !! 1) :: Int
        let medicoId = read (avaliacao !! 2) :: Int
        let nota = read (avaliacao !! 3) :: Int
        let comentario = avaliacao !! 4
        [(Avaliacao idAvaliacao pacienteId medicoId nota comentario, "")]
