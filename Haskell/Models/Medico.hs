module Haskell.Models.Medico where

import Haskell.App.Util (boolToString, split)

import Prelude hiding(id)


data Medico = Medico {
    clinica :: Int,
    id :: Int,
    nome :: String,
    crm :: String,
    especialidade :: String,
    senha :: String,
    nota :: Float
}

toString :: Medico -> String
toString m = show (clinica m) ++ ";" ++
             show (id m) ++ ";" ++
             nome m ++ ";" ++
             crm m ++ ";" ++
             especialidade m ++ ";" ++
             senha m ++ ";" ++
             show (nota m)

instance Show Medico where
    
    show (Medico clinica id nome crm esp _ _) =  "----------------------------\n" ++
                                            "Médico " ++ (show id) ++ "\n" ++
                                            "Nome: " ++ nome ++ "\n" ++
                                            "CRM: " ++ crm ++ "\n" ++
                                            "Clínica: " ++ (show clinica) ++ "\n" ++
                                            "Especialidade: " ++ esp ++ "\n" ++
                                            "-------------------\n"

instance Read Medico where
    readsPrec _ str = do
        let medico = split str ';' ""
        let clinica = read (medico !! 0) :: Int
        let id = read (medico !! 1) :: Int
        let nome = medico !! 2
        let crm = medico !! 3
        let especialidade = medico !! 4
        let senha = if (length medico == 7) then medico !! 5 else ""
        let nota = if (length medico == 7) then read (medico !! 6) :: Float else 0.0
        [(Medico clinica id nome crm especialidade senha nota, "")]

toStringAval :: Medico -> String
toStringAval m = "----------------------------\n" ++
                                            "Médico " ++ (show (id m)) ++ "\n" ++
                                            "Nome: " ++ nome m ++ "\n" ++
                                            "CRM: " ++ crm m ++ "\n" ++
                                            "Clínica: " ++ show (clinica m) ++ "\n" ++
                                            "Especialidade: " ++ especialidade m ++ "\n" ++
                                            "Nota: " ++ show (nota m) ++ "\n" ++
                                            "-------------------\n"

                                
