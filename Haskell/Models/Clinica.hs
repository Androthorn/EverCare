module Haskell.Models.Clinica (
    Clinica (..),
    toString
) where

import Prelude hiding (id)
import Haskell.App.Util (split)
import Data.List (intercalate)


data Clinica = Clinica {
    id :: Int,
    nome :: String,
    endereço :: String,
    horarios :: String,
    planos :: [String],
    metodoAgendamento :: String,
    contato :: String,
    senha :: String
    
}

toString :: Clinica -> String
toString u =
    show (id u) ++ ";" ++
         (nome u) ++ ";" ++
         (endereço u) ++ ";" ++
         (horarios u) ++ ";" ++
         (intercalate "," (planos u)) ++ ";" ++
         (metodoAgendamento u) ++ ";" ++
         (contato u) ++ ";" ++
         (senha u)

instance Show Clinica where
    show (Clinica id n e h p m c _) = "----------------------------\n" ++
                                      "Clinica  " ++ (show id) ++ "\n" ++
                                      "Nome: " ++ n ++ "\n" ++
                                      "Endereço: " ++ e ++ "\n" ++
                                      "Horários: " ++ h ++ "\n" ++
                                      "Planos: " ++ (concatMap (++ ", ") p) ++ "\n" ++
                                      "Método de Agendamento: " ++ m ++ "\n" ++
                                      "Contato: " ++ "\n" ++
                                      "----------------------------\n"


instance Read Clinica where
    readsPrec _ str = do
        let clinica = split str ';' ""
        let id = read (clinica !! 0) :: Int
        let nome = clinica !! 1
        let endereco = clinica !! 2
        let horarios = clinica !! 3
        let planos = split (clinica !! 4) ',' ""
        let metodoAgendamento = clinica !! 5  
        let contato = clinica !! 6
        let senha = clinica !! 7
        [(Clinica id nome endereco horarios planos metodoAgendamento contato senha, "")]
