module Consulta where

import Data.Time.Clock
import Data.Time.Format
import Data.Time.LocalTime
    ( utcToLocalTime, hoursToTimeZone, TimeZone )

data Consulta = Consulta {
    id :: Int,
    idPaciente :: Int,
    idClinica :: Int,  
    idMedico :: Int,
    dataConsulta :: UTCTime,
    horario :: String
}

toString :: Consulta -> String
toString cons =
    show (Consulta.id cons) ++ ";" ++
    show (idPaciente cons) ++ ";" ++ 
    show (idMedico cons) ++ ";" ++
    show (idClinica cons) ++ ";" ++
    formatarDataHoraBrasileira (dataConsulta cons) ++ ";" ++
    horario cons

consultaParaUsuario :: Consulta -> String
consultaParaUsuario cons = "A consulta " ++ (show (Consulta.id cons)) ++ " do paciente " ++ (show (idPaciente cons)) ++ " com o(a) médico(a) " ++ (show (idMedico cons)) ++ " em " ++ formatarDataHoraBrasileira (dataConsulta cons) ++ " às " ++ horario cons

instance Show Consulta where
    show consulta = "Foi marcada a consulta { ID: " ++ show (Consulta.id consulta) ++
                    ", idPaciente: " ++ show (idPaciente consulta) ++
                    ", idClinica: " ++ show (idClinica consulta) ++
                    ", idMedico: " ++ show (idMedico consulta) ++
                    ", dataConsulta: " ++ show (formatarDataHoraBrasileira (dataConsulta consulta)) ++
                    ", horario: " ++ horario consulta ++ " }"

instance Read Consulta where
    readsPrec _ input =
        let [(id', resto1)] = reads input
            [(idPaciente', resto2)] = reads resto1
            [(idClinica', resto3)] = reads resto2
            [(idMedico', resto4)] = reads resto3
            [(dataConsulta', resto5)] = reads resto4
            [(horario', resto6)] = reads resto5
        in [(Consulta id' idPaciente' idClinica' idMedico' dataConsulta' horario', resto6)]

fusoBr :: TimeZone
fusoBr = hoursToTimeZone (-3)

formatarDataHoraBrasileira :: UTCTime -> String
formatarDataHoraBrasileira = formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S" . utcToLocalTime fusoBr
