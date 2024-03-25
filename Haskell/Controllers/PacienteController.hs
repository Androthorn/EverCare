{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}

module Haskell.Controllers.PacienteController (
    criaPaciente
) where

import qualified Haskell.Models.BD as BD
import Haskell.Models.Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate)
import qualified Haskell.Models.Receita as Receita


{-
Cria um paciente.
@param idP: Inteiro que representa o id do paciente.
@param infos: Lista de strings que contém as informações do paciente.
@return paciente criado.
-}
criaPaciente :: Int -> [String] -> Paciente
criaPaciente idP infos = read (intercalate ";" ([show (idP)] ++ infos)) :: Paciente

{-
Essa função filtra uma lista de médicos com base na especialidade desejada.
@param especialidadeDesejada: A especialidade que se deseja encontrar nos médicos.
@param medicos: Uma lista de médicos que será filtrada.
@return Uma lista de médicos que possuem a especialidade desejada.
-}

filtrarMedicosPorEspecialidade :: String -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicosPorEspecialidade especialidadeDesejada medicos  =
    filter (\medico -> Medico.especialidade medico == especialidadeDesejada) medicos

{-
Essa função filtra uma lista de laudos com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do paciente desejado.
-}
consultarLaudo :: Int -> [Laudo] -> [Laudo]
consultarLaudo _ [] = []
consultarLaudo idPaciente laudos = filter (\laudo -> Laudo.id laudo == idPaciente) laudos

{-
Essa função filtra uma lista de receitas com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nas receitas.
@param receitas: Uma lista de receitas que será filtrada.
@return Uma lista de receitas que possuem o id do paciente desejado.
-}
consultarReceita :: Int -> [Receita.Receita] -> [Receita.Receita]
consultarReceita _ [] = []
consultarReceita idPaciente receita = filter (\receita -> Receita.idPaciente receita == idPaciente) receita

-- Função para enviar mensagem de paciente para médico
enviarMensagemParaMedico :: Int -> String -> IO ()
enviarMensagemParaMedico idMedico mensagem = do
    appendFile "mensagens.txt" $ "P:" ++ show idMedico ++ ";" ++ mensagem ++ "\n"

-- Função para listar todas as mensagens recebidas por um paciente
listarMensagensRecebidas :: Int -> IO ()
listarMensagensRecebidas idPaciente = do
    conteudo <- readFile "mensagens.txt"
    let mensagens = filter (\m -> take 2 m == "M:" ++ show idPaciente) (lines conteudo)
    mapM_ (mostrarMensagem) mensagens

-- Função para ler mensagens de um médico específico
lerMensagensDeMedico :: Int -> Int -> IO ()
lerMensagensDeMedico idPaciente idMedico = do
    conteudo <- readFile "mensagens.txt"
    let mensagens = filter (\m -> take 4 m == "P:" ++ show idPaciente ++ ";" ++ show idMedico) (lines conteudo)
    mapM_ (mostrarMensagem) mensagens

-- Função para mostrar a mensagem com o nome do remetente no início
mostrarMensagem :: String -> IO ()
mostrarMensagem mensagem = do
    let (tipo, idRemetente, texto) = splitMessage mensagem
    case tipo of
        "M" -> do
            medico <- getNomeMedico (read idRemetente)
            putStrLn $ "Médico " ++ nome medico ++ ": " ++ texto
        _ -> putStrLn $ "Paciente: " ++ texto

-- Função para obter o nome do médico pelo ID
getNomeMedico :: Int -> IO Medico
getNomeMedico idMedico = do
    conteudo <- readFile "medicos.txt"
    let medicos = lines conteudo
    let medicoInfo = filter (\m -> take 1 m == show idMedico) medicos
    return $ parseMedico (head medicoInfo)

-- Função para dividir uma mensagem nos campos tipo, ID do remetente e texto
splitMessage :: String -> (String, String, String)
splitMessage mensagem = (tipo, idRemetente, texto)
    where
        (tipo:idRemetente:texto) = split ';' mensagem

-- Função para analisar uma string e criar um objeto Médico
parseMedico :: String -> Medico
parseMedico str = undefined  -- Implemente conforme a estrutura do seu modelo Médico