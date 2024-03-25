module Controllers.MedicoController where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate, find)
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Receita as Laudo


{-
Essa função filtra uma lista de laudos com base no id do médico.
@param idMedico: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do médico desejado.
-}
consultarLaudo :: Int -> [Laudo.Laudo] -> [Laudo.Laudo]
consultarLaudo _ [] = []
consultarLaudo idMedico laudos = filter (\laudo -> Laudo.idMed laudo == idMedico) laudos

-- Isso não deveria ser uma função de Paciente? Não entendi (Virginia)
{-
Essa função filtra uma lista de receitas com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nas receitas.
@param receitas: Uma lista de receitas que será filtrada.
@return Uma lista de receitas que possuem o id do paciente desejado.
-}
consultarReceita :: Int -> [Receita.Receita] -> [Receita.Receita]
consultarReceita _ [] = []
consultarReceita idPaciente receitas = filter (\receita -> Receita.idPaciente receita == idPaciente) receitas

-- Função para enviar mensagem de médico para paciente
enviarMensagemParaPaciente :: Int -> String -> IO ()
enviarMensagemParaPaciente idPaciente mensagem = do
    appendFile "mensagens.txt" $ "M:" ++ show idPaciente ++ ";" ++ mensagem ++ "\n"

-- Função para listar todas as mensagens recebidas por um médico
listarMensagensRecebidas :: Int -> IO ()
listarMensagensRecebidas idMedico = do
    conteudo <- readFile "mensagens.txt"
    let mensagens = filter (\m -> take 2 m == "P:" ++ show idMedico) (lines conteudo)
    mapM_ (mostrarMensagem) mensagens

-- Função para ler mensagens de um paciente específico
lerMensagensDePaciente :: Int -> Int -> IO ()
lerMensagensDePaciente idMedico idPaciente = do
    conteudo <- readFile "mensagens.txt"
    let mensagens = filter (\m -> take 4 m == "M:" ++ show idMedico ++ ";" ++ show idPaciente) (lines conteudo)
    mapM_ (mostrarMensagem) mensagens

-- Função para mostrar a mensagem com o nome do remetente no início
mostrarMensagem :: String -> IO ()
mostrarMensagem mensagem = do
    let (tipo, idRemetente, texto) = splitMessage mensagem
    case tipo of
        "P" -> do
            paciente <- getNomePaciente (read idRemetente)
            putStrLn $ "Paciente " ++ nome paciente ++ ": " ++ texto
        _ -> putStrLn $ "Médico: " ++ texto

-- Função para obter o nome do paciente pelo ID
getNomePaciente :: Int -> IO Paciente
getNomePaciente idPaciente = do
    conteudo <- readFile "pacientes.txt"
    let pacientes = lines conteudo
    let pacienteInfo = filter (\p -> take 1 p == show idPaciente) pacientes
    return $ parsePaciente (head pacienteInfo)

-- Função para dividir uma mensagem nos campos tipo, ID do remetente e texto
splitMessage :: String -> (String, String, String)
splitMessage mensagem = (tipo, idRemetente, texto)
    where
        (tipo:idRemetente:texto) = split ';' mensagem

-- Função para analisar uma string e criar um objeto Paciente
parsePaciente :: String -> Paciente
parsePaciente str = undefined  -- Implemente conforme a estrutura do seu modelo Paciente

{- 
Essa função retorna o ID do medico dado o seu nome.
@param name: nome do medico
@param medicos: lista de medicos cadastrados
@return o ID do medico
-}
getMedicoId :: String -> [Medico.Medico] -> Int
getMedicoId name medicos = 
    case find (\medico -> Medico.nome medico == name) medicos of
        Just medico -> Medico.id medico
        Nothing -> error "paciente not found"