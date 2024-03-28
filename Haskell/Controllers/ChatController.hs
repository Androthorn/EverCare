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


{-
Função para criar um chat.
@param id: ID do chat.
@param idPaciente: ID do paciente participante do chat.
@param idMedico: ID do médico participante do chat.
@param mensagem: Mensagem inicial do chat.
@return o chat criado.
-}
criarChat :: Int -> Int -> Int -> String -> Chat.Chat
criarChat id idPaciente idMedico mensagem = Chat.Chat id idPaciente idMedico [mensagem]

{-
Esta função retorna os chats de um paciente.
@param idPaciente: ID do paciente.
@param chats: Lista de todos os chats.
@param medicos: Lista de médicos associados aos chats.
@return uma string representando os chats do paciente.
-}
verChatsPaciente :: Int -> [Chat.Chat] -> [Medico.Medico] -> String
verChatsPaciente _ [] [] = []
verChatsPaciente _ [] _ = []
verChatsPaciente _ _ [] = []
verChatsPaciente idPaciente chats medicos =
    let filtrado = filter (\chat -> Chat.idPaciente chat == idPaciente) chats
        chatsString = map (\chat -> showChat chat medicos) filtrado
    in unlines chatsString

{-
Esta função retorna os chats de um médico.
@param idMedico: ID do médico.
@param chats: Lista de todos os chats.
@param pacientes: Lista de pacientes associados aos chats.
@return uma string representando os chats do médico.
-}
verChatsMedico :: Int -> [Chat.Chat] -> [Paciente.Paciente] -> String
verChatsMedico _ [] [] = []
verChatsMedico _ [] _ = []
verChatsMedico _ _ [] = []
verChatsMedico idMedico chats pacientes =
    let filtrado = filter (\chat -> Chat.idMedico chat == idMedico) chats
        chatsString = map (\chat -> showChatM chat pacientes) filtrado
    in unlines chatsString

{-
Esta função retorna informações sobre um chat específico.
@param idChat: ID do chat.
@param chats: Lista de todos os chats.
@return uma string representando informações sobre o chat específico.
-}
verChatEspecifico :: Int -> [Chat.Chat] -> String
verChatEspecifico _ [] = ""
verChatEspecifico idChat chats =
    let filtrado = filter (\chat -> Chat.id chat == idChat) chats
    in show (head filtrado)

{-
Esta função mostra informações sobre um chat entre um médico e um paciente.
@param chat: O chat a ser exibido.
@param pacientes: Lista de pacientes associados aos chats.
@return uma string representando informações sobre o chat específico.
-}
showChatM :: Chat.Chat -> [Paciente.Paciente] -> String
showChatM chat pacientes = "----------------------------\n" ++
                "CHAT " ++ (show (Chat.id chat)) ++ "\n" ++
                "Paciente: " ++ ((PC.getPacienteName (Chat.idPaciente chat) pacientes)) ++ "\n" ++
                "Médico: " ++ (show (Chat.idMedico chat)) ++ "\n" ++
                "Mensagens: " ++ (show (Chat.mensagens chat)) ++ "\n"

{-
Esta função mostra informações sobre um chat entre um paciente e um médico.
@param chat: O chat a ser exibido.
@param medicos: Lista de médicos associados aos chats.
@return uma string representando informações sobre o chat específico.
-}
showChat :: Chat.Chat -> [Medico.Medico] -> String
showChat chat medicos = "----------------------------\n" ++
                "CHAT " ++ (show (Chat.id chat)) ++ "\n" ++
                "Paciente: " ++ (show (Chat.idPaciente chat)) ++ "\n" ++
                "Médico: " ++ (MC.getIdMedico (Chat.idMedico chat) medicos) ++ "\n" ++
                "Mensagens: " ++ (show (Chat.mensagens chat)) ++ "\n"
