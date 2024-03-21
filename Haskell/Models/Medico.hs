module Haskell.Models.Medico where

import Haskell.App.Util (boolToString, split)
  
import Prelude hiding(id)


data Medico = Medico {
    id :: Int,
    nome :: String,
    crm :: String,
    clinica :: Int,
    especialidade :: String,
    horarios :: String
}

toString :: Medico -> String
toString m = show (clinica m) ++ ";" ++
             show (id m) ++ ";" ++
             nome m ++ ";" ++
             crm m ++ ";" ++
             especialidade m ++ ";" ++
             show (horarios m)

instance Show Medico where
    show (Medico id nome crm clinica esp _) =  "----------------------------\n" ++
                                            "Médico " ++ (show id) ++ "\n" ++
                                            "Nome: " ++ nome ++ "\n" ++
                                            "CRM: " ++ crm ++ "\n" ++
                                            "Clínica: " ++ (show clinica) ++ "\n" ++
                                            "Especialidade: " ++ esp ++ "\n"

instance Read Medico where
    readsPrec _ str = do
        let medico = split str ';' ""
        let id = read (medico !! 1) :: Int
        let nome = medico !! 2
        let crm = medico !! 3
        let clinica = read (medico !! 0) :: Int
        let especialidade = medico !! 4
        let horarios = if (length medico == 6) then read (medico !! 5) :: String else ""

        [(Medico id nome crm clinica especialidade horarios, "")]