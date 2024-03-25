module Haskell.Models.BD where

import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Chat as Chat


import System.IO
import System.Directory
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)


data BD = BD {
    pacientes :: [Paciente.Paciente],
    medicos :: [Medico.Medico],
    clinicas :: [Clinica.Clinica],
    consultas :: [Consulta.Consulta],
    chats :: [Chat.Chat],
    idAtualPaciente :: Int,
    idAtualMedico :: Int,
    idAtualClinica :: Int,
    idAtualConsulta :: Int
} deriving (Show)


-- Função que cria um novo BD
novoBD :: BD
novoBD = BD {
    pacientes = [],
    medicos = [],
    clinicas = [],
    consultas = [],
    chats = [],
    idAtualPaciente = 1,
    idAtualMedico = 1,
    idAtualClinica = 1,
    idAtualConsulta = 1
}

novoBanco :: IO BD
novoBanco = do
    let pacientesIO = uploadPacientes "Haskell/Persistence/pacientes.txt"
    let clinicaIO = uploadClinicas "Haskell/Persistence/clinicas.txt"
    let medicosIO = uploadMedicos "Haskell/Persistence/medicos.txt"
    let consultasIO = uploadConsultas "Haskell/Persistence/consultas.txt"
    let chatsIO = uploadChats "Haskell/Persistence/chats.txt"
    pacientes <- pacientesIO
    clinicas <- clinicaIO
    medicos <- medicosIO
    consultas <- consultasIO
    chats <- chatsIO
    let bd = BD {
            pacientes = pacientes,
            medicos = medicos,
            clinicas = clinicas,
            consultas = consultas,
            chats = chats,
            idAtualPaciente = length pacientes + 1,
            idAtualMedico = length medicos + 1,
            idAtualClinica = length clinicas + 1,
            idAtualConsulta = length consultas +1
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

uploadConsultas :: FilePath -> IO [Consulta.Consulta]
uploadConsultas path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let consultasList = stringToConsultas linhas
    return consultasList

uploadChats :: FilePath -> IO [Chat.Chat]
uploadChats path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let chatsList = stringToChats linhas
    return chatsList

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

stringToChats :: [String] -> [Chat.Chat]
stringToChats [] = []
stringToChats l = map read l :: [Chat.Chat]

stringToClinicas :: [String] -> [Clinica.Clinica]
stringToClinicas [] = []
stringToClinicas l = map read l :: [Clinica.Clinica]

consultasToString :: [Consulta.Consulta] -> String -> String
consultasToString [] str = str
consultasToString (x:xs) str = str ++ (Consulta.toString x) ++ "\n" ++ consultasToString xs str

stringToConsultas :: [String] -> [Consulta.Consulta]
stringToConsultas [] = []
stringToConsultas l = map read l :: [Consulta.Consulta]

medicosToString :: [Medico.Medico] -> String -> String
medicosToString [] str = str
medicosToString (x:xs) str = str ++ (Medico.toString x) ++ "\n" ++ medicosToString xs str

stringToMedicos :: [String] -> [Medico.Medico]
stringToMedicos [] = []
stringToMedicos l = map read l :: [Medico.Medico]