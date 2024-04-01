{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
module Haskell.Controllers.ChatController(
    criarChat,
    verChatsPaciente,
    verChatEspecifico,
    showChat,
    verChatsMedico
) where

import Data.List ( intercalate )
import qualified Haskell.Models.Chat as Chat
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Controllers.MedicoController as MC (getIdMedico)
import Haskell.Controllers.PacienteController as PC (getPacienteName)

import Haskell.Models.Medico as Medico


-- Função para criar um chat
criarChat :: Int -> Int -> Int -> String -> Chat.Chat
criarChat id idPaciente idMedico mensagem = Chat.Chat id idPaciente idMedico [mensagem]

verChatsPaciente :: Int -> [Chat.Chat] -> String
verChatsPaciente _ [] = []
verChatsPaciente idPaciente chats =
    let filtrado = filter (\chat -> Chat.idPaciente chat == idPaciente) chats
        chatsString = map (\chat -> showChat chat) filtrado
    in unlines chatsString

verChatsMedico :: Int -> [Chat.Chat] -> [Paciente.Paciente] -> String
verChatsMedico _ [] [] = []
verChatsMedico _ [] _ = []
verChatsMedico _ _ [] = []
verChatsMedico idMedico chats pacientes =
    let filtrado = filter (\chat -> Chat.idMedico chat == idMedico) chats
        chatsString = map (\chat -> showChatM chat pacientes) filtrado
    in unlines chatsString

verChatEspecifico :: Int -> [Chat.Chat] -> String
verChatEspecifico _ [] = ""
verChatEspecifico idChat chats =
    let filtrado = filter (\chat -> Chat.id chat == idChat) chats
    in show (head filtrado)

showChatM :: Chat.Chat -> [Paciente.Paciente] -> String
showChatM chat pacientes = "----------------------------\n" ++
                "CHAT " ++ (show (Chat.id chat)) ++ "\n" ++
                "Paciente: " ++ ((PC.getPacienteName (Chat.idPaciente chat) pacientes)) ++ "\n" ++
                "Médico: " ++ (show (Chat.idMedico chat)) ++ "\n" ++
                "Mensagens: " ++ (show (Chat.mensagens chat)) ++ "\n"

showChat :: Chat.Chat -> String
showChat chat = "----------------------------\n" ++
                "CHAT " ++ (show (Chat.id chat)) ++ "\n" ++
                "Paciente: " ++ (show (Chat.idPaciente chat)) ++ "\n" ++
                "Médico: " ++ (show (Chat.idMedico chat)) ++ "\n" ++
                "Mensagens: " ++ (show (Chat.mensagens chat)) ++ "\n"
