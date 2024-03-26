module Haskell.Controllers.ClinicaController(
    criaChart,
    enviaMensagem,
    listaChats,
    abrirChat
) where

import Data.List ( intercalate )
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico



-- Função para criar um chat
criaChat :: Int -> Int -> String -> IO ()
criaChatP idRemetente idDestinatario mensagem = read (intercalate ";" ([show (idPaciente), show (idMedico), mensagem])) :: Chat
   
-- Função para enviar mensagem 
enviarMensagem :: Int -> String -> IO ()
enviarMensagem idChat mensagem = read (intercalate ";" ([show (idChat), mensagem])) :: Chat

-- Função para listar todas as mensagens recebidas 
listarChats :: Int -> [Chat.Chat] -> IO ()
listarChats idID chats = filter (\chat -> Chat.idPaciente chat == idPaciente) chats

-- Função para ler mensagens de um médico específico
lerChatEspecifico:: Int -> [Chat.Chat] -> IO ()
lerChatEspecifico idChat chats = filter (\chat -> Chat.id chat == idChat) chats

