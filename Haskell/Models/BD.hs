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
    idAtualPaciente = 1,
    idAtualMedico = 1,
    idAtualClinica = 1
}

novoBanco :: IO BD
novoBanco = do
    let pacientesIO = uploadPacientes "Haskell/Persistence/pacientes.txt"
    let clinicaIO = uploadClinicas "Haskell/Persistence/clinicas.txt"
    let medicosIO = uploadMedicos "Haskell/Persistence/medicos.txt"
    pacientes <- pacientesIO
    clinicas <- clinicaIO
    medicos <- medicosIO
    let bd = BD {
            pacientes = pacientes,
            medicos = medicos,
            clinicas = clinicas,
            idAtualPaciente = length pacientes + 1,
            idAtualMedico = length medicos + 1,
            idAtualClinica = length clinicas + 1
        }
    return bd

uploadPacientes :: FilePath -> IO [Paciente.Paciente]
uploadPacientes path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let pacientsList = stringToPacientes linhas
    return pacientsList

uploadClinicas :: FilePath -> IO [Clinica.Clinica]
uploadClinicas path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let clinicasList = stringToClinicas linhas
    return clinicasList

uploadMedicos :: FilePath -> IO [Medico.Medico]
uploadMedicos path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let medicosList = stringToMedicos linhas
    return medicosList

escreveNoArquivo :: FilePath -> String -> IO ()
escreveNoArquivo path conteudo = do
    handle <- openFile path AppendMode
    hSetEncoding handle utf8
    hPutStrLn handle conteudo
    hClose handle

escreveNoArquivo2 :: FilePath -> String -> IO ()
escreveNoArquivo2 path conteudo = do
    appendFile path (conteudo ++ "\n")


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