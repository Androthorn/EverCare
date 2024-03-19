module Haskell.Model.Clinica where
import Haskell.View.Utils (split)


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
         (endereco u) ++ ";" ++
         (horarios u) ++ ";" ++
         (planos u) ++ ";" ++
         (contato u)

instance Show Clinica where
    show (Clinica id n e h p c) = "----------------------------\n" ++
                        "Clinica  " ++ (show id) ++ "\n" ++
                        "Nome: " ++ n ++ "\n" ++
                        "Endereço: " ++ e "\n" ++
                        "Horários: " ++ h "\n" ++
                        "Planos: " ++ p "\n" ++
                        "Contato: " ++ c
                        
instance Read Clinica where
    readsPrec _ str = do
        let l = split str ';' ""
        let id = read (l !! 0) :: Int
        let nome = l !! 1
        let endereco = l !! 2
        let horarios = read (l !! 3) :: DateCycle
        let planos = l !! 4
        let contato = l !! 5
        [(Clinica id nome endereco horarios planos contato, "")]
 
    