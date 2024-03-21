module Haskell.Models.DataBase where

import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Models.Clinica

data BD = BD {
    pacientes :: [Paciente.Paciente],
    medicos :: [Medico.Medico],
    clinicas :: [Clinica],
    loginsPacientes :: [(Int, String)],
    idAtualPaciente :: Int,
    idAtualMedico :: Int,
    idAtualClinica :: Int
} deriving (Show)

-- Função que cria um novo BD
novoBD :: BD
novoBD = BD {
    pacientes = [],
    medicos = [],
    clinicas = [],
    loginsPacientes = [],
    idAtualPaciente = 1,
    idAtualMedico = 1,
    idAtualClinica = 1
}

pacientesToString :: [Paciente.Paciente] -> String -> String
pacientesToString [] str = str
pacientesToString (x:xs) str = str ++ (Paciente.toString x ) ++ "\n" ++ pacientesToString xs str

stringToPacientes :: [String] -> [Paciente.Paciente]
stringToPacientes [] = []
stringToPacientes l = map read l :: [Paciente.Paciente]

medicosToString :: [Medico.Medico] -> String -> String
medicosToString [] str = str
medicosToString (x:xs) str = str ++ (Medico.toString x) ++ "\n" ++ medicosToString xs str


loginsPacientesToString :: [(Int, String)] -> String -> String
loginsPacientesToString [] str = str
loginsPacientesToString (x:xs) str = str ++ (show x) ++ "\n" ++ loginsPacientesToString xs str

stringToLoginsPaciente :: [String] -> [(Int, String)]
stringToLoginsPaciente [] = []
stringToLoginsPaciente l = map read l :: [(Int, String)]
