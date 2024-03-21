module Models.Clinica where

import Prelude hiding (id)
import App.Util (split)


data Clinica = Clinica {
    id :: Int,
    nome :: String,
    endereço :: String,
    horarios :: String,
    planos :: String,
    contato :: String
    
}

toString :: Clinica -> String
toString u =
    show (id u) ++ ";" ++
         (nome u) ++ ";" ++
         (endereço u) ++ ";" ++
         (horarios u) ++ ";" ++
         (planos u) ++ ";" ++
         (contato u)

instance Show Clinica where
    show (Clinica id n e h p c) = "----------------------------\n" ++
                        "Clinica  " ++ (show id) ++ "\n" ++
                        "Nome: " ++ n ++ "\n" ++
                        "Endereço: " ++ e ++ "\n" ++
                        "Horários: " ++ h ++ "\n" ++
                        "Planos: " ++ p ++ "\n" ++
                        "Contato: " ++ c


instance Read Clinica where
    readsPrec _ str = do
        let clinica = split str ';' ""
        let id = read (clinica !! 0) :: Int
        let nome = clinica !! 1
        let endereco = clinica !! 2
        let horarios = read (clinica !! 3) :: String
        let planos = clinica !! 4
        let contato = clinica !! 5
        [(Clinica id nome endereco horarios planos contato, "")]
