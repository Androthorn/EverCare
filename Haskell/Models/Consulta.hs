module Haskell.Models.Consulta where

import Data.Char
import Data.Maybe
import Data.Time.Clock
import Data.Time.Format
import Data.Time.LocalTime
    ( utcToLocalTime, hoursToTimeZone, TimeZone )
import Haskell.App.Util 

data Consulta = Consulta {
    consId :: Int,
    idPaciente :: String,
    idClinica :: String,  
    idMedico :: String,
    dataConsulta :: String,
    horario :: String
}

toString :: Consulta -> String
toString cons =
    show (consId cons) ++ ";" ++
    show (idPaciente cons) ++ ";" ++ 
    show (idMedico cons) ++ ";" ++
    show (idClinica cons) ++ ";" ++
    show (dataConsulta cons) ++ ";" ++
    horario cons

consultaParaUsuario :: Consulta -> String
consultaParaUsuario cons = "A consulta " ++ show (consId cons) ++ " do paciente " ++ show (idPaciente cons) ++ " com o(a) médico(a) " ++ show (idMedico cons) ++ " em " ++  dataConsulta cons ++ " às " ++ horario cons

instance Show Consulta where
    show (Consulta idCons idPac idClin idMed dataC hora) = "-------------------\n" ++
                    "Id da Consulta: " ++ show idCons ++ "\n" ++
                    "Nome do paciente: " ++ idPac ++ "\n" ++
                    "Nome da Clínica: "  ++ idClin ++ "\n" ++
                    "Nome do Médico: " ++ idMed ++ "\n" ++
                    "Data da consulta" ++ dataC ++ "\n" ++
                    "Hora da consulta" ++ hora ++ "\n" ++
                    "-------------------\n"

instance Read Consulta where
    readsPrec :: Int -> ReadS Consulta
    readsPrec _ str = do
        let consulta = split str ';' ""
        let consultaId = read (consulta !! 0) :: Int
        let nomePaciente = consulta !! 1
        let nomeClinica = consulta !! 2
        let nomeMedico = consulta !! 3
        let datas = consulta !! 4
        let hora = consulta !! 5
        return (Consulta consultaId nomePaciente nomeClinica nomeMedico datas hora, "")


--funcoes legado para (talvez) futuro uso
fusoBr :: TimeZone
fusoBr = hoursToTimeZone (-3)

formatarDataHoraBrasileira :: UTCTime -> String
formatarDataHoraBrasileira = formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S" . utcToLocalTime fusoBr
