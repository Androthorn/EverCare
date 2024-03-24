module Haskell.Models.Laudo where
import Haskell.App.Util (split)
import Prelude hiding (id)

data Laudo = Laudo {
     id :: Int,
     idMed :: Int,
     idPac :: Int,
     texto :: String
}

toString :: Laudo -> String
toString l =
     show (id l) ++ ";" ++
     show (idMed l) ++ ";" ++
     show (idPac l) ++ ";" ++
     texto l

instance Show Laudo where
    show (Laudo id idM idP t) = "----------------------------\n" ++
                                "LAUDO " ++ (show id) ++ "\n" ++
                                "Médico responsável: " ++ (show idM) ++ "\n" ++
                                "Paciente: " ++ (show idP) ++ "\n" ++
                                "Resultado: " ++ t

instance Read Laudo where
     readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idMed = read (l !! 1) :: Int
        let idPac = read (l !! 2) :: Int
        let texto = l !! 3

        [(Laudo id idMed idPac texto, "")]