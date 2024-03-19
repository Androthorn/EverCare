module Haskell.Model.Medico where
import Prelude hiding(id)
import Haskell.View.Utils (split)
import Haskell.View.Utils (split, formataBool)

data Medico = Medico {
    id :: Int,
    nome :: String,
    crm :: String,
    clinica :: Int,
    especialidade :: String,
    horarios :: String
}

toString :: Medico -> String
toString m = show (idclinica m) ++ ";" ++
             show (id m) ++ ";" ++
             nome m ++ ";" ++
             crm m ++ ";" ++
             especialidade m ++ ";" ++
             show (horarios m)

instance Show Medico where
    show (Medico id n c idU e _) =  "----------------------------\n" ++
                                    "Médico " ++ (show id) ++ "\n" ++
                                    "Nome: " ++ n ++ "\n" ++
                                    "CRM: " ++ c ++ "\n" ++
                                    "Clínica: " ++ (show clinica) ++ "\n" ++
                                    "Especialidade: " ++ e ++ "\n"

instance Read Medico where
    readsPrec _ str = do
    let l = split str ';' 
    let id = read (l !! 1) :: Int
    let nome = l !! 2
    let crm = l !! 3
    let clinica = read (l !! 0) :: Int
    let especialidade = l !! 4
    let horarios = if (length l == 6) then read (l !! 5) :: String else empty
    [(Medico id nome crm clinica especialidade horarios, "")]