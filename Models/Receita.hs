module Haskell.Model.Receita where
import Haskell.View.Utils (split)
import Prelude hiding (id)

data Receita = Receita {
    id :: Int,
    idPaciente :: Int,
    idMedico :: Int,
    remedios :: [(Int, String, Int)]
}

toString :: Receita -> String
toString r =
    show (id r) ++ ";" ++
    show (idPaciente r) ++ ";" ++
    show (idMedico r) ++ ";" ++
    show (remedios r)

instance Show Receita where
    show (Receita id idP idM idU rem) = "----------------------------\n" ++
                                        "RECEITUÁRIO " ++ (show id) ++ "\n" ++
                                        "Paciente: " ++ (show idP) ++ "\n" ++
                                        "Médico responsável: " ++ (show idM) ++ "\n" ++
                                        "Remédios" ++ "\n" ++ formataRemedios rem

formataRemedios :: [(Int, String, Int)] -> String
formataRemedios [] = ""
formataRemedios ((id, inst, qtd):xs) = "ID Remédio: " ++ (show id) ++ " - " ++ "Qtd: " ++ (show qtd) ++ "\n" ++
                                       "----- Instruções -------" ++ "\n" ++ inst ++ "\n\n" ++
                                       formataRemedios xs

instance Read Receita where
    readsPrec _ str = do
    let l = split str ';' ""
    let id = read (l !! 0) :: Int
    let idPaciente = read (l !! 1) :: Int
    let idMedico = read (l !! 2) :: Int
    let remedios = read (l !! 3) :: [(Int, String, Int)]
    [(Receita id idPaciente idMedico idUBS remedios, "")]