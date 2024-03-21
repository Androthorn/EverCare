module Haskell.Models.BD where

import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Clinica as Clinica
import System.IO
import System.Directory
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)


data BD = BD {
    pacientes :: [Paciente.Paciente],
    medicos :: [Medico.Medico],
    clinicas :: [Clinica.Clinica],
    loginsPacientes :: [(Int, String)],
    loginsClinica :: [(Int, String)],
    loginsMedico :: [(Int, String)],
    idAtualPaciente :: Int,
    idAtualMedico :: Int,
    idAtualClinica :: Int
} deriving (Show)

novoBanco :: IO BD
novoBanco = return novoBD

-- Função que cria um novo BD
novoBD :: BD
novoBD = BD {
    pacientes = [],
    medicos = [],
    clinicas = [],
    loginsPacientes = [],
    loginsClinica = [],
    loginsMedico = [],
    idAtualPaciente = 1,
    idAtualMedico = 1,
    idAtualClinica = 1
}



pacienteNoArquivo :: FilePath -> Paciente.Paciente -> IO ()
pacienteNoArquivo path paciente = do
    appendFile path ((Paciente.toString paciente) ++ "\n")

medicoNoArquivo :: FilePath -> Medico.Medico -> IO ()
medicoNoArquivo path medico = do
    appendFile path ((Medico.toString medico) ++ "\n")


clinicaNoArquivo :: FilePath -> Clinica.Clinica -> IO ()
clinicaNoArquivo path clinica = do
    appendFile path ((Clinica.toString clinica) ++ "\n")



pacientesToString :: [Paciente.Paciente] -> String -> String
pacientesToString [] str = str
pacientesToString (x:xs) str = str ++ (Paciente.toString x) ++ "\n" ++ pacientesToString xs str

stringToPacientes :: [String] -> [Paciente.Paciente]
stringToPacientes [] = []
stringToPacientes l = map read l :: [Paciente.Paciente]

clinicasToString :: [Clinica.Clinica] -> String -> String
clinicasToString [] str = str
clinicasToString (x:xs) str = str ++ (Clinica.toString x) ++ "\n" ++ clinicasToString xs str

stringToClinicas :: [String] -> [Clinica.Clinica]
stringToClinicas [] = []
stringToClinicas l = map read l :: [Clinica.Clinica]

medicosToString :: [Medico.Medico] -> String -> String
medicosToString [] str = str
medicosToString (x:xs) str = str ++ (Medico.toString x) ++ "\n" ++ medicosToString xs str

stringToMedicos :: [String] -> [Medico.Medico]
stringToMedicos [] = []
stringToMedicos l = map read l :: [Medico.Medico]

loginsPacientesToString :: [(Int, String)] -> String -> String
loginsPacientesToString [] str = str
loginsPacientesToString (x:xs) str = str ++ (show x) ++ "\n" ++ loginsPacientesToString xs str

stringToLoginsPaciente :: [String] -> [(Int, String)]
stringToLoginsPaciente [] = []
stringToLoginsPaciente l = map read l :: [(Int, String)]

loginsClinicaToString :: [(Int, String)] -> String -> String
loginsClinicaToString [] str = str
loginsClinicaToString (x:xs) str = str ++ (show x) ++ "\n" ++ loginsClinicaToString xs str

stringToLoginsClinica :: [String] -> [(Int, String)]
stringToLoginsClinica [] = []
stringToLoginsClinica l = map read l :: [(Int, String)]

loginsMedicoToString :: [(Int, String)] -> String -> String
loginsMedicoToString [] str = str
loginsMedicoToString (x:xs) str = str ++ (show x) ++ "\n" ++ loginsMedicoToString xs str

stringToLoginsMedico :: [String] -> [(Int, String)]
stringToLoginsMedico [] = []
stringToLoginsMedico l = map read l :: [(Int, String)]