{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Haskell.Models.Fila where
import Haskell.App.Util (split)
import Prelude hiding (id)
import Data.List (intercalate)

data Fila = Fila {
    id :: Int,
    idClinica :: Int,
    idMedico :: Int,
    fila :: [String]
}

toString :: Fila -> String
toString f =
    show (id f) ++ ";" ++
    show (idClinica f) ++ ";" ++
    show (idMedico f) ++ ";" ++
    (intercalate "," (fila f))

instance Show Fila where
    show (Fila id idC idM f) = "----------------------------\n" ++
                                    "FILA " ++ (show id) ++ "\n" ++
                                    "Clínica: " ++ (show idC) ++ "\n" ++
                                    "Médico: " ++ (show idM) ++ "\n" ++
                                    "Fila: " ++ (show f) ++ "\n"

instance Read Fila where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idClinica = read (l !! 1) :: Int
        let idMedico = read (l !! 2) :: Int
        let fila = if (length l == 4) then split (l !! 3) ',' "" else do []
        [(Fila id idClinica idMedico fila, "")]