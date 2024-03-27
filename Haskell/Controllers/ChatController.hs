{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
module Haskell.Controllers.ChatController(
    criarChat,
    verChatsPaciente,
    verChatEspecifico,
    showChat
) where

import Data.List ( intercalate )
import qualified Haskell.Models.Chat as Chat
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Controllers.MedicoController as MC (getIdMedico)
import Haskell.Models.Medico as Medico


-- Função para criar um chat
criarChat :: Int -> Int -> Int -> String -> Chat.Chat
criarChat id idPaciente idMedico mensagem = Chat.Chat id idPaciente idMedico [mensagem]

verChatsPaciente :: Int -> [Chat.Chat] -> [Medico.Medico] -> [String]
verChatsPaciente _ [] [] = []
verChatsPaciente _ [] _ = []
verChatsPaciente _ _ [] = []
verChatsPaciente idPaciente chats medicos =
    let filtrado = filter (\chat -> Chat.idPaciente chat == idPaciente) chats
    in map show filtrado
    -- in map (\chat -> showChat chat medicos) filtrado

verChatEspecifico :: Int -> [Chat.Chat] -> String
verChatEspecifico _ [] = ""
verChatEspecifico idChat chats =
    let filtrado = filter (\chat -> Chat.id chat == idChat) chats
    in show (head filtrado)

showChat :: Chat.Chat -> [Medico.Medico] -> String
showChat chat medicos = "----------------------------\n" ++
                "CHAT " ++ (show (Chat.id chat)) ++ "\n" ++
                "Paciente: " ++ (show (Chat.idPaciente chat)) ++ "\n" ++
                "Médico: " ++ (MC.getIdMedico (Chat.idMedico chat) medicos) ++ "\n"
