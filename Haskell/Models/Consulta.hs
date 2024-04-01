module Haskell.Models.Consulta where

import Data.Char
import Data.Maybe
import Data.Time.Clock
import Data.Time.Format
import Data.Time.LocalTime ( utcToLocalTime, hoursToTimeZone, TimeZone )
import Haskell.App.Util 

data Consulta = Consulta {
    idConsulta :: Int,
    idPaciente :: Int,
    idClinica :: Int,  
    idMedico :: Int,
    dataConsulta :: String,
    horario :: String,
    queixas :: String,
    confirmado :: Bool
}


toString :: Consulta -> String
toString cons =      show (idConsulta cons) ++
              ";" ++ show (idPaciente cons) ++
              ";" ++ show (idClinica cons) ++
              ";" ++ show (idMedico cons) ++
              ";" ++ dataConsulta cons ++
              ";" ++ horario cons ++
              ";" ++ queixas cons ++
              ";" ++ show (confirmado cons)

instance Show Consulta where
    show (Consulta idCons idPac idClin idMed dataC hora queixas confirmado) = "-------------------\n" ++
                    "Id da Consulta: " ++ show idCons ++ "\n" ++
                    "Id do paciente: " ++ show idPac ++ "\n" ++
                    "Id da Clínica: "  ++ show idClin ++ "\n" ++
                    "Id do Médico: " ++ show idMed ++ "\n" ++
                    "Data da consulta: " ++ dataC ++ "\n" ++
                    "Hora da consulta: " ++ hora ++ "\n" ++
                    "Queixas: " ++ queixas ++ "\n" ++
                    "Confirmado: " ++ show confirmado ++ "\n" ++
                    "-------------------\n"

instance Read Consulta where
    
    readsPrec _ str = do
        let consulta = split str ';' ""
        let consultaId = read (consulta !! 0) :: Int
        let idPaciente = read (consulta !! 1) :: Int
        let idClinica = read (consulta !! 2) :: Int
        let idMedico = read (consulta !! 3) :: Int
        let datas = consulta !! 4
        let hora = consulta !! 5
        let queixas = consulta !! 6
        let confirmado = if (length consulta) == 8 then read (consulta !! 7) :: Bool else False
        return (Consulta consultaId idPaciente idClinica idMedico datas hora queixas confirmado, "")


--funcoes legado para (talvez) futuro uso
fusoBr :: TimeZone
fusoBr = hoursToTimeZone (-3)

formatarDataHoraBrasileira :: UTCTime -> String
formatarDataHoraBrasileira = formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S" . utcToLocalTime fusoBr
