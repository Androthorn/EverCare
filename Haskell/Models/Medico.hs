module Haskell.Models.Medico where

import Haskell.App.Util (boolToString, split)

import Prelude hiding(id)


data Medico = Medico {
    clinica :: Int,
    id :: Int,
    nome :: String,
    crm :: String,
    especialidade :: String,
    horarios :: String, 
    senha :: String
}

toString :: Medico -> String
toString m = show (clinica m) ++ ";" ++
             show (id m) ++ ";" ++
             nome m ++ ";" ++
             crm m ++ ";" ++
             especialidade m ++ ";" ++
             horarios m ++ ";" ++
             senha m

instance Show Medico where
    show (Medico clinica id nome crm esp horario _) =  "----------------------------\n" ++
                                            "Médico " ++ (show id) ++ "\n" ++
                                            "Nome: " ++ nome ++ "\n" ++
                                            "CRM: " ++ crm ++ "\n" ++
                                            "Clínica: " ++ (show clinica) ++ "\n" ++
                                            "Especialidade: " ++ esp ++ "\n" ++
                                            "Horários de Atendimento: " ++ horario ++ "\n" ++
                                            "-------------------\n"

instance Read Medico where
    readsPrec _ str = do
        let medico = split str ';' ""
        let clinica = read (medico !! 0) :: Int
        let id = read (medico !! 1) :: Int
        let nome = medico !! 2
        let crm = medico !! 3
        let especialidade = medico !! 4
        let horarios = if (length medico == 7) then medico !! 5 else ""
        let senha = if (length medico == 7) then medico !! 6 else ""

        [(Medico clinica id nome crm especialidade horarios senha, "")]