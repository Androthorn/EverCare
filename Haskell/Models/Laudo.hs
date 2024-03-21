module Haskell.Models.Laudo where
import Haskell.App.Util (split)
import Prelude hiding (id)

data Laudo = Laudo {
     id :: Int,
     idMed :: Int,
     texto :: String
}

toString :: Laudo -> String
toString l =
     show (id l) ++ ";" ++
     show (idMed l) ++ ";" ++
     texto l

instance Show Laudo where
    show (Laudo id idM t) = "----------------------------\n" ++
                                "LAUDO " ++ (show id) ++ "\n" ++
                                "Médico responsável: " ++ (show idM) ++ "\n" ++
                                "Resultado: " ++ t

instance Read Laudo where
     readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let idMed = read (l !! 1) :: Int
        let texto = l !! 2

        [(Laudo id idMed texto, "")]