module Haskell.Models.BD where

import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Chat as Chat
import qualified Haskell.Models.Exame as Exame
import qualified Haskell.Models.Laudo as Laudo
import qualified Haskell.Models.Receita as Receita


import System.IO
import System.Directory
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import Distribution.Compat.CharParsing (CharParsing(string))


data BD = BD {
    pacientes :: [Paciente.Paciente],
    medicos :: [Medico.Medico],
    clinicas :: [Clinica.Clinica],
    consultas :: [Consulta.Consulta],
    chats :: [Chat.Chat],
    exames:: [Exame.Exame],
    laudos :: [Laudo.Laudo],
    receitas :: [Receita.Receita],
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
    exames = [],
    receitas = [],
    laudos = [],
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
    let examesIO = uploadExames "Haskell/Persistence/exames.txt"
    let laudosIO = uploadLaudos "Haskell/Persistence/laudos.txt"
    let receitasIO = uploadReceitas "Haskell/Persistence/receitas.txt"
    pacientes <- pacientesIO
    clinicas <- clinicaIO
    medicos <- medicosIO
    consultas <- consultasIO
    chats <- chatsIO
    exames <- examesIO
    laudos <- laudosIO
    receitas <- receitasIO
    let bd = BD {
            pacientes = pacientes,
            medicos = medicos,
            clinicas = clinicas,
            consultas = consultas,
            chats = chats,
            exames = exames,
            laudos = laudos,
            receitas = receitas,
            idAtualPaciente = length pacientes + 1,
            idAtualMedico = length medicos + 1,
            idAtualClinica = length clinicas + 1,
            idAtualConsulta = length consultas +1
        }
    return bd

uploadReceitas :: FilePath -> IO [Receita.Receita]
uploadReceitas path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let receitasList = stringToReceitas linhas
    return receitasList

uploadLaudos :: FilePath -> IO [Laudo.Laudo]
uploadLaudos path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let laudosList = stringToLaudos linhas
    return laudosList

stringToLaudos :: [String] -> [Laudo.Laudo]
stringToLaudos [] = []
stringToLaudos l = map read l :: [Laudo.Laudo]

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

uploadExames :: FilePath -> IO [Exame.Exame]
uploadExames path = do
    conteudo <- readFile path
    let linhas = lines conteudo
    let examesList = stringToExames linhas
    return examesList

stringToExames :: [String] -> [Exame.Exame]
stringToExames [] = []
stringToExames l = map read l :: [Exame.Exame]

escreveNoArquivo :: FilePath -> String -> IO ()
escreveNoArquivo path conteudo = do
    handle <- openFile path AppendMode
    hSetEncoding handle utf8
    hPutStrLn handle conteudo
    hClose handle

escreveNoArquivo2 :: FilePath -> String -> IO ()
escreveNoArquivo2 path conteudo = do
    appendFile path (conteudo ++ "\n")

stringToReceitas :: [String] -> [Receita.Receita]
stringToReceitas [] = []
stringToReceitas l = map read l :: [Receita.Receita]

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


horariosMarcados :: BD -> Int -> String -> [String]
horariosMarcados bd idMedico dia =
    let consultasDoDia = filter (\consulta -> Consulta.dataConsulta consulta == dia) (consultas bd)
        consultasDoMedico = filter (\consulta -> Consulta.idMedico consulta == idMedico) consultasDoDia
    in consultasToHorarios consultasDoMedico

horariosDisponiveis :: BD -> Int -> String -> [String]
horariosDisponiveis bd idMedico dia =
    let horarios = ["08:00", "09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00"]
    in filter (\horario -> notElem horario (horariosMarcados bd idMedico dia)) horarios

consultasToHorarios :: [Consulta.Consulta] -> [String]
consultasToHorarios consultas = map (\consulta -> Consulta.horario consulta) consultas
