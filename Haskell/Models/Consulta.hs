module Haskell.Models.Consulta where

import Data.Char
import Data.Maybe
import Data.Time.Clock
import Data.Time.Format
import Data.Time.LocalTime ( utcToLocalTime, hoursToTimeZone, TimeZone )
import Haskell.App.Util 

data Consulta = Consulta {
    idConsulta :: Int,
    nomePaciente :: String,
    nomeClinica :: String,  
    nomeMedico :: String,
    dataConsulta :: String,
    horario :: String
}

consultaParaUsuario :: Consulta -> String
consultaParaUsuario cons = "A consulta " ++ show (idConsulta cons) ++ " do paciente " ++ show (nomePaciente cons) ++ " com o(a) médico(a) " ++ show (nomeMedico cons) ++ " em " ++  dataConsulta cons ++ " às " ++ horario cons


toString :: Consulta -> String
toString cons =
    show (idConsulta cons) ++ ";" ++
    nomePaciente cons ++ ";" ++ 
    nomeClinica cons ++ ";" ++
    nomeMedico cons ++ ";" ++
    dataConsulta cons ++ ";" ++
    horario cons

instance Show Consulta where
    show (Consulta idCons nomePac nomeClin nomeMed dataC hora) = "-------------------\n" ++
                    "Id da Consulta: " ++ show idCons ++ "\n" ++
                    "Nome do paciente: " ++ nomePac ++ "\n" ++
                    "Nome da Clínica: "  ++ nomeClin ++ "\n" ++
                    "Nome do Médico: " ++ nomeMed ++ "\n" ++
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
