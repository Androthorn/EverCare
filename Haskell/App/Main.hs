{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Redundant if" #-}
{-# LANGUAGE OverloadedStrings #-}
{-# HLINT ignore "Use /=" #-}
{-# HLINT ignore "Use infix" #-}

import Haskell.App.Util
import qualified Haskell.Models.BD as BD
import qualified Haskell.Controllers.PacienteController as PControl
import qualified Haskell.Controllers.AutenticationController as Autenticator
import qualified Haskell.Controllers.ClinicaController as CControl
import qualified Haskell.Controllers.MedicoController as MControl
import qualified Haskell.Controllers.ChatController as ChatControl

import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Laudo as Laudo
import qualified Haskell.Models.Exame as Exame
import qualified Haskell.Models.Chat as Chat
import qualified Haskell.Models.Avaliacao as Avaliacao
import qualified Haskell.Models.Fila as Fila
import Data.Time
import Data.List ( elemIndex, sort )
import Data.Char ( toUpper )
import Control.Concurrent (threadDelay)
import Control.Monad.RWS.Lazy (MonadState(put))
import System.IO
import System.Directory
import System.Process (system)
import Haskell.Models.BD (BD(idAtualPaciente))
import Data.Text.Internal.Read (IParser(P))
import GHC.Base (VecElem(Int16ElemRep))
import Text.Read (readMaybe, get)
import Text.XHtml (menu, th)
import Data.Maybe (fromJust)



main :: IO ()
main = do
    dados <- BD.novoBanco
    inicial dados

inicial :: BD.BD -> IO()
inicial dados = do
    limpaTela
    putStrLn (titulo)
    putStrLn (escolheEntidade)

    op <- prompt "Opção > "
    if toUpper (head op) == 'P' then do
        inicialPaciente dados

    else if toUpper (head op) == 'C' then do
        inicialClinica dados

    else if toUpper (head op) == 'M' then do
        inicialMedico dados

    else if toUpper (head op) == 'S' then do
        putStrLn "Saindo..."
        threadDelay 1000000

    else do
        putStrLn "Opção inválida"
        inicial dados

inicialPaciente :: BD.BD -> IO()
inicialPaciente dados = do
    limpaTela
    putStrLn (tituloI "PACIENTE")
    putStrLn (escolheLogin)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'C' then do
        cadastraPaciente dados
    else if toUpper (head op2) == 'L' then do
        loginPaciente dados
    else if toUpper (head op2) == 'V' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        inicialPaciente dados

cadastraPaciente :: BD.BD -> IO()
cadastraPaciente dados = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE PACIENTE")
    dadosP <- leituraDadosPaciente

    putStrLn ("Paciente cadastrado com sucesso! Seu id é: " ++ (show (BD.idAtualPaciente dados)))
    threadDelay 2000000

    let paciente = PControl.criaPaciente (BD.idAtualPaciente dados) dadosP
    BD.escreveNoArquivo "Haskell/Persistence/pacientes.txt" (Paciente.toString paciente)

    loginPaciente dados { BD.pacientes = (BD.pacientes dados) ++ [paciente],
                          BD.idAtualPaciente = (BD.idAtualPaciente dados) + 1 }
    inicialPaciente dados


loginPaciente :: BD.BD -> IO()
loginPaciente dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE PACIENTE")
    idStr <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""

    case readMaybe idStr :: Maybe Int of
        Just id -> do
            let aut = Autenticator.autenticaPaciente (BD.pacientes dados) id senha
            if aut then do
                menuPaciente id dados
            else do
                putStrLn "ID ou senha incorretos"
                threadDelay 1000000
                inicialPaciente dados
        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            inicialPaciente dados


menuPaciente :: Int -> BD.BD -> IO()
menuPaciente idPac dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD PACIENTE")
    putStrLn (dashboardPaciente)
    op <- prompt "Opção > "

    if toUpper (head op) == 'B' then do
        buscar idPac dados

    else if toUpper (head op) == 'M' then do
        cadastraConsulta idPac dados

    else if toUpper (head op) == 'B' then do
        buscar idPac dados

    else if toUpper (head op) == 'V' then do
        verAgendamento idPac dados

    else if toUpper (head op) == 'R' then do
        verPosConsulta idPac dados

    else if toUpper (head op) == 'A' then do
        cadastraAvaliacao idPac dados

    else if toUpper (head op) == 'S' then do
        inicial dados

    else if toUpper (head op) == 'C' then do
        chatsPac idPac dados

    else if toUpper (head op) == 'F' then do
        filaVirtualPac idPac dados

    else do
        putStrLn "Opção inválida"
        menuPaciente idPac dados

filaVirtualPac :: Int -> BD.BD -> IO()
filaVirtualPac idPac dados = do
    limpaTela
    putStrLn (tituloI "PACIENTE - FILA VIRTUAL")
    putStrLn (filaVirtualP)
    op <- prompt "Opção > "
    let consultasP = filter (\consulta -> Consulta.idPaciente consulta == idPac) (BD.consultas dados)

    if toUpper (head op) == 'E' then do
        putStrLn "\n"
        idMedico <- prompt "ID do Médico > "
        case readMaybe idMedico :: Maybe Int of
            Just idM -> do
                if notElem idM (map Medico.id (BD.medicos dados)) then do
                    putStrLn "Médico não cadastrado"
                    threadDelay 1000000
                    menuPaciente idPac dados
                else do
                    if notElem idM (map Consulta.idMedico consultasP) then do
                        putStrLn "Você não possui consulta com esse médico"
                        threadDelay 2000000
                        menuPaciente idPac dados
                    else do
                        if notElem idM (map Fila.idMedico (BD.filas dados)) then do
                            putStrLn "Clínica ainda não iniciou a fila para esse médico!"
                            threadDelay 2000000
                            menuPaciente idPac dados
                        else do
                            let bdAtualizado = entraFilaVirtual idPac idM (BD.filas dados) dados
                            let fiLA = filter (\fila -> Fila.idMedico fila == idM) (BD.filas bdAtualizado)
                            let fila = head fiLA
                            putStrLn ("Você está na posição " ++ (show (length (Fila.fila fila))) ++ " da fila")

                            BD.limpaArquivo "Haskell/Persistence/filas.txt"
                            BD.escreveNoArquivoSemContra "Haskell/Persistence/filas.txt" (BD.filasToString (BD.filas bdAtualizado) "")
                            threadDelay 2000000
                            menuPaciente idPac bdAtualizado
            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                threadDelay 1000000
                menuPaciente idPac dados


    else if toUpper (head op) == 'V' then do
        idFStr <- prompt "ID da Fila > "
        case readMaybe idFStr :: Maybe Int of
            Just idF -> do
                if notElem idF (map Fila.id (BD.filas dados)) then do
                    putStrLn "ID da Fila inválido"
                    threadDelay 1000000
                    menuPaciente idPac dados
                else do
                    let index = verfilas idF idPac dados
                    if index == Nothing then do
                        putStrLn "Você não está na fila"
                        threadDelay 1000000
                        menuPaciente idPac dados
                    else do
                        putStrLn ("Você está na posição " ++ (show (fromJust index + 1)) ++ " da fila")
                        threadDelay 2000000
                        prompt "Pressione Enter para voltar"
                        filaVirtualPac idPac dados

            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                threadDelay 1000000
                menuPaciente idPac dados

    else if toUpper (head op) == 'S' then do
        menuPaciente idPac dados

    else do
        putStrLn "Opção inválida"
        filaVirtualPac idPac dados

verfilas :: Int -> Int -> BD.BD -> Maybe Int
verfilas idF idPac dados =
    let fila = head (filter (\fila -> (Fila.id fila) == idF) (BD.filas dados))
        name = PControl.getPacienteName idPac (BD.pacientes dados)
    in elemIndex name (Fila.fila fila)


entraFilaVirtual :: Int -> Int ->[Fila.Fila] -> BD.BD -> BD.BD
entraFilaVirtual idPac idM filas dados =
    let filasList = filter (\fila -> Fila.idMedico fila == idM) filas
        fila = head filasList
        filaId = Fila.id fila
        filasAtualizadas = map (\filaP -> if filaId == Fila.id filaP then adicionaFila filaP idPac (BD.pacientes dados) else filaP) filas
        bdAtualizado = dados { BD.filas = filasAtualizadas }
    in do
        bdAtualizado

adicionaFila :: Fila.Fila -> Int -> [Paciente.Paciente] -> Fila.Fila
adicionaFila fila idPac pacientes =
    let filaAtualizada = fila { Fila.fila = Fila.fila fila ++ [PControl.getPacienteName idPac pacientes] }
    in filaAtualizada


buscar :: Int -> BD.BD -> IO()
buscar idPac dados = do
    limpaTela
    putStrLn (tituloI "BUSCAR")
    putStrLn (dashboardBusca)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        buscarClinicas idPac dados

    else if toUpper (head op) == 'M' then do
        buscarMedicos idPac dados

    else if toUpper (head op) == 'V' then do
        menuPaciente idPac dados
    else do
        putStrLn "Opção inválida"
        buscar idPac dados

buscarClinicas :: Int -> BD.BD -> IO()
buscarClinicas idPac dados = do
    limpaTela
    putStrLn (tituloI "BUSCAR CLÍNICAS")
    putStrLn (dashboardBuscaClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        nomeClinica <- prompt "Nome da Clínica > "
        let clinicas = PControl.filtrarPorClinica nomeClinica (BD.clinicas dados)
        if null clinicas then do
            putStrLn "Clínica não encontrada"
            threadDelay 1000000
            buscarClinicas idPac dados
        else do
            imprime clinicas
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados

    else if toUpper (head op) == 'P' then do
        plano <- prompt "Plano de Saúde ou Particular > "
        let clinicas = PControl.filtrarClinicasPorPlanoDeSaude plano (BD.clinicas dados)
        if null clinicas then do
            putStrLn "Clínica não encontrada"
            threadDelay 1000000
            buscarClinicas idPac dados
        else do
            imprime clinicas
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados
    
    else if toUpper (head op) == 'T' then do
        tipo <- prompt "Tipo do Agendamento [(A)gendamento ou (O)rdem de Chegada] > "
        let clinicas = PControl.filtrarClinicasPorAgendamento tipo (BD.clinicas dados)
        if null clinicas then do
            putStrLn "Nenhuma clínica encontrada com esse tipo de agendamento"
            threadDelay 1000000
            buscarClinicas idPac dados
        else do
            imprime clinicas
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados

    else if toUpper (head op) == 'V' then do
        buscar idPac dados

    else do
        putStrLn "Opção inválida"
        buscarClinicas idPac dados

buscarMedicos :: Int -> BD.BD -> IO()
buscarMedicos idPac dados = do
    limpaTela
    putStrLn (tituloI "BUSCAR MÉDICO")
    putStrLn (dashboardBuscaMedico)
    op <- prompt "Opção > "

    if toUpper (head op) == 'M' then do
        nomeMedico <- prompt "Nome do Médico > "
        let medicos = PControl.filtrarPorMedico nomeMedico (BD.medicos dados)
        if null medicos then do
            putStrLn "Médico não encontrado"
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            imprime medicos
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados

    else if toUpper (head op) == 'C' then do
        nomeClinica <- prompt "Nome da Clínica > "
        let idClinicaMaybe = CControl.getClinicaId nomeClinica (BD.clinicas dados)
        if idClinicaMaybe == -1 then do
            putStrLn "Clínica não encontrada"
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            let idClinica = idClinicaMaybe
            let medicos = BD.filtraMedicosDaClinica dados idClinica
            if null medicos then do
                putStrLn "Nenhum médico encontrado nessa clínica"
                threadDelay 1000000
                buscarMedicos idPac dados
            else do
                imprime medicos
                prompt "Pressione Enter para voltar"
                menuPaciente idPac dados

    else if toUpper (head op) == 'H' then do
        dia <- prompt "Dia > "
        if not (isValidDate dia) then do
            putStrLn "Data inválida"
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            hora <- prompt "Horário > "
            if not (isValidHour hora) then do
                putStrLn "Hora inválida"
                threadDelay 1000000
                buscarMedicos idPac dados
            else do
                let medicos = BD.filtraMedicosNoHorario dados dia hora
                if null medicos then do
                    putStrLn "Nenhum médico disponível nesse horário"
                    threadDelay 1000000
                    buscarMedicos idPac dados
                else do
                    imprime medicos
                    prompt "Pressione Enter para voltar"
                    menuPaciente idPac dados

    else if toUpper (head op) == 'E' then do
        especialidade <- prompt "Especialidade > "
        let medicos = BD.filtraMedicoPorEspecialidade dados especialidade
        if null medicos then do
            putStrLn "Nenhum médico encontrado com essa especialidade"
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            imprime medicos
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados
    
    else if toUpper (head op) == 'A' then do
        acimaStr <- prompt "Avaliação acima de (0-10) > "
        let acimaValor = read acimaStr :: Float
        let medicos = (PControl.filtrarMedicosPorAvaliacoes acimaValor (BD.medicos dados))
        let avaliacoes = map Medico.toStringAval medicos
        if null avaliacoes then do
            putStrLn "Nenhum médico encontrado com avaliação acima do esperado."
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            putStrLn (unlines avaliacoes)
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados
    
    else if toUpper (head op) == 'S' then do
        sintoma <- prompt "Descreva o que está sentindo > "
        let medicos = BD.filtrarMedicoPorSintoma dados sintoma
        if null medicos then do
            putStrLn "Nenhum médico encontrado com esse sintoma"
            threadDelay 1000000
            buscarMedicos idPac dados
        else do
            imprime medicos
            prompt "Pressione Enter para voltar"
            menuPaciente idPac dados

    else if toUpper (head op) == 'V' then do
        buscar idPac dados

    else do
        putStrLn "Opção inválida"
        buscarMedicos idPac dados

cadastraConsulta :: Int -> BD.BD -> IO()
cadastraConsulta idPac dados = do
    limpaTela
    putStr (tituloI "AGENDAMENTO DE CONSULTA")
    idStrC <- prompt "ID da Clínica > "

    case readMaybe idStrC :: Maybe Int of
        Just idC -> do
            let clinica = head (filter (\clinica -> Clinica.id clinica == idC) (BD.clinicas dados))
            idStrM <- prompt "ID do Médico > "
            case readMaybe idStrM :: Maybe Int of
                Just idM -> do

                    let medicos = BD.filtraMedicosDaClinica dados idC
                    if notElem idM (map Medico.id medicos) then do
                        putStrLn "\nID do Médico não pertence a Clínica"
                        threadDelay 1000000
                        cadastraConsulta idPac dados

                    else do
                        dia <- prompt "Data da Consulta > "
                        if not (isValidDate dia) then do
                            putStrLn "\nData inválida"
                            threadDelay 1000000
                            cadastraConsulta idPac dados
                        else do
                            if (head (Clinica.metodoAgendamento clinica) == 'O') then do
                                queixas <- prompt "Queixas > "
                                putStrLn ("Consulta marcada com sucesso! O id da consulta é: " ++ (show (BD.idAtualConsulta dados)))
                                putStrLn "Essa consulta é por ordem de chegada."
                                threadDelay 2000000

                                let dadosCons = [show idPac, idStrC, idStrM, dia, "00:00", queixas]

                                let consulta = PControl.criaConsulta (BD.idAtualConsulta dados) (dadosCons)
                                BD.escreveNoArquivo "Haskell/Persistence/consultas.txt" (Consulta.toString consulta)
                                menuPaciente idPac dados { BD.consultas = (BD.consultas dados) ++ [consulta],
                                                        BD.idAtualConsulta = (BD.idAtualConsulta dados) + 1 }
                            else do
                                let horarios = BD.horariosDisponiveis dados idM dia
                                putStrLn "\nHorários disponíveis: "
                                imprimeEmUmaLinha horarios
                                putStrLn ""

                                horario <- prompt "Horário > "
                                if notElem horario horarios then do
                                    putStrLn "\nHorário indisponível"
                                    threadDelay 1000000
                                    cadastraConsulta idPac dados
                                else do
                                    queixas <- prompt "Queixas > "
                                    putStrLn ("Consulta marcada com sucesso! o id da consulta é: " ++ (show (BD.idAtualConsulta dados)))
                                    threadDelay 2000000

                                    let dadosCons = [show idPac, idStrC, idStrM, dia, horario, queixas]

                                    let consulta = PControl.criaConsulta (BD.idAtualConsulta dados) (dadosCons)
                                    BD.escreveNoArquivo "Haskell/Persistence/consultas.txt" (Consulta.toString consulta)
                                    menuPaciente idPac dados { BD.consultas = (BD.consultas dados) ++ [consulta],
                                                            BD.idAtualConsulta = (BD.idAtualConsulta dados) + 1 }

                Nothing -> do
                    putStrLn "\nID do Médico deve ser um inteiro"
                    threadDelay 1000000
                    cadastraConsulta idPac dados

        Nothing -> do
            putStrLn "\nID da Clínica ser um inteiro"
            threadDelay 1000000
            cadastraConsulta idPac dados


cadastraAvaliacao :: Int -> BD.BD -> IO ()
cadastraAvaliacao idPac dados = do
    let avaliacoes =  BD.avaliacoes dados
    let consultas = BD.filtraConsultasDoPaciente dados idPac
    limpaTela
    putStrLn (tituloI "AVALIAÇÃO DE ATENDIMENTO")

    idMedStr <- prompt "ID do Médico > "
    case readMaybe idMedStr :: Maybe Int of
        Just idMed -> do
            if notElem idMed (map Consulta.idMedico consultas) then do
                putStrLn "Você não possui consulta com esse médico!"
                threadDelay 1000000
                menuPaciente idPac dados
            else do
                notaStr <- prompt "Nota (0-10) > "
                case readMaybe notaStr :: Maybe Int of
                    Just nota -> do
                        if nota < 0 || nota > 10 then do
                            putStrLn "Nota deve ser um inteiro entre 0 e 10"
                            threadDelay 1000000
                            menuPaciente idPac dados
                        else do
                            texto <- prompt "Texto > "
                            let idAvaliacao = BD.idAtualAvaliacao dados
                            let notaFloat = fromIntegral nota
                            let avaliacao = Avaliacao.Avaliacao idAvaliacao idPac idMed nota texto
                            putStrLn ("Avaliação cadastrada com sucesso! O id da sua avaliação é: " ++ (show (BD.idAtualAvaliacao dados)))
                            threadDelay 2000000

                            timeZoneBR <- getCurrentTimeZone
                            currentTime <- getCurrentTime
                            let formattedTime = formatTime defaultTimeLocale "%d-%m-%Y %H:%M:%S" (utcToZonedTime timeZoneBR currentTime)

                            BD.escreveNoArquivo "Haskell/Persistence/avaliacoes.txt" (Avaliacao.toString avaliacao ++ ";" ++ formattedTime)

                            let bdAtualizado = dados { BD.avaliacoes = avaliacoes ++ [avaliacao],
                                                        BD.idAtualAvaliacao = (BD.idAtualAvaliacao dados) + 1 }
                            let bdMAtualizado = atualizaBDmedicos idMed bdAtualizado

                            BD.limpaArquivo "Haskell/Persistence/medicos.txt"
                            BD.escreveNoArquivoSemContra "Haskell/Persistence/medicos.txt" (BD.medicosToString (BD.medicos bdMAtualizado) "")

                            menuPaciente idPac bdMAtualizado

                    Nothing -> do
                        putStrLn "Nota deve ser um inteiro"
                        threadDelay 1000000
                        menuPaciente idPac dados

        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            menuPaciente idPac dados


atualizaBDmedicos :: Int -> BD.BD -> BD.BD
atualizaBDmedicos idMed dados = do
    let medicosAtualizados = MControl.adicionaMedia idMed (BD.avaliacoes dados) (BD.medicos dados)
        bdAtualizado = dados { BD.medicos = medicosAtualizados }
    bdAtualizado

chatsPac :: Int -> BD.BD -> IO()
chatsPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHAT PACIENTE")
    putStrLn (chatP)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        criarChatP idPac dados

    else if toUpper (head op) == 'V' then do
        visualizaTodosChatsPac idPac dados

    else if toUpper (head op) == 'A' then do
        abrirConversaPac idPac dados

    else if toUpper (head op) == 'S' then do
        menuPaciente idPac dados

    else do
        putStrLn "Opção inválida"
        chatsPac idPac dados

criarChatP :: Int -> BD.BD -> IO()
criarChatP idPac dados = do
    limpaTela
    putStrLn (tituloI "MANDAR MENSAGEM")
    idMStr <- prompt "Id do Médico > "

    let consultas = BD.filtraConsultasDoPaciente dados idPac

    case readMaybe idMStr :: Maybe Int of
        Just idMedico -> do
            if notElem idMedico (map Consulta.idMedico consultas) then do
                putStrLn "Você não possui consulta com esse médico!"
                threadDelay 1000000
                chatsPac idPac dados
            else do
                mensagem <- prompt "Mensagem > "
                putStrLn ("Mensagem enviada com sucesso! O id da sua mensagem é: " ++ (show (BD.idAtualChat dados)))
                threadDelay 2000000
                let chat = ChatControl.criarChat (BD.idAtualChat dados) idPac idMedico ("P: " ++ mensagem)

                BD.escreveNoArquivo "Haskell/Persistence/chats.txt" (Chat.toString chat)
                menuPaciente idPac dados { BD.chats = (BD.chats dados) ++ [chat],
                                    BD.idAtualChat = (BD.idAtualChat dados) + 1 }

        Nothing -> do
            putStrLn "Médico não cadastrado."
            threadDelay 1000000
            chatsPac idPac dados


visualizaTodosChatsPac :: Int -> BD.BD -> IO()
visualizaTodosChatsPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHATS DO PACIENTE")
    putStrLn (ChatControl.verChatsPaciente idPac (BD.chats dados))
    prompt "Pressione Enter para voltar"
    menuPaciente idPac dados

abrirConversaPac :: Int -> BD.BD -> IO()
abrirConversaPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHAT PACIENTE")
    idChatStr <- prompt "Id do Chat > "

    let chatsPaciente = filter (\chat -> Chat.idPaciente chat == idPac) (BD.chats dados)

    case readMaybe idChatStr :: Maybe Int of
        Just idChat -> do
            if notElem idChat (map Chat.id (BD.chats dados)) then do
                putStrLn "ID do Chat inválido"
                threadDelay 1000000
                chatsPac idPac dados
            else do
                if notElem idChat (map Chat.id chatsPaciente) then do
                    putStrLn "Chat não pertence ao paciente"
                    threadDelay 1000000
                    chatsPac idPac dados
                else do
                    putStrLn (ChatControl.verChatEspecifico idChat (BD.chats dados))
                    op <- prompt "[E]nviar Mensagem ou [S]air > "

                    if toUpper (head op) == 'E' then do
                        mensagem <- prompt "Mensagem > "
                        let dadosA = adicionarMensagemAoChat idChat ("P: " ++ mensagem) dados
                        BD.limpaArquivo "Haskell/Persistence/chats.txt"
                        BD.escreveNoArquivoSemContra "Haskell/Persistence/chats.txt" (BD.chatsToString (BD.chats dadosA))
                        menuPaciente idPac dadosA

                    else if toUpper (head op) == 'S' then do
                        menuPaciente idPac dados

                    else do
                        putStrLn "Opção inválida"
                        abrirConversaPac idPac dados
        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            abrirConversaPac idPac dados
    menuPaciente idPac dados

adicionarMensagemAoChat :: Int -> String -> BD.BD -> BD.BD
adicionarMensagemAoChat chatId novaMensagem dados =
    let chatsAtualizados = map (\chat -> if chatId == Chat.id chat then adicionarMensagem chat novaMensagem else chat) (BD.chats dados)
        bdAtualizado = dados { BD.chats = chatsAtualizados }
    in do
        bdAtualizado

adicionarMensagem :: Chat.Chat -> String -> Chat.Chat
adicionarMensagem chat novaMensagem = chat { Chat.mensagens = Chat.mensagens chat ++ [novaMensagem] }


verPosConsulta :: Int -> BD.BD -> IO()
verPosConsulta idPac dados = do
    limpaTela
    putStrLn (tituloI "RECEITAS / LAUDOS / SOLICITAÇÕES DE EXAMES")
    putStrLn (emissaoPaciente)
    op <- prompt "Opção > "

    if toUpper (head op) == 'R' then do
        let resultado = PControl.consultarReceita idPac (BD.receitas dados)
        imprime resultado
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'L' then do
        let resultado = PControl.consultarLaudo idPac (BD.laudos dados)
        imprime resultado
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'S' then do
        let resultado = PControl.consultarSolicitacao idPac (BD.exames dados)
        imprime resultado
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'V' then do
        menuPaciente idPac dados

    else do
        putStrLn "Opção inválida"
        verPosConsulta idPac dados


verAgendamento :: Int -> BD.BD -> IO()
verAgendamento idPac dados = do
    limpaTela
    putStrLn (tituloI "AGENDAMENTOS")
    let consultas = PControl.consultarAgendamento idPac (BD.consultas dados)
    imprime consultas
    op <- prompt "Confirmar ou Cancelar Alguma Consulta? [S/N] > "
    if toUpper (head op) == 'S' then do

        idConsultaStr <- prompt "ID da Consulta > "
        case readMaybe idConsultaStr :: Maybe Int of
            Just idConsulta -> do
                if notElem idConsulta (map Consulta.idConsulta consultas) then do
                    putStrLn "ID da Consulta não marcada por você"
                    threadDelay 2000000
                    menuPaciente idPac dados
                else do
                    let consulta = head (filter (\consulta -> Consulta.idConsulta consulta == idConsulta) consultas)
                    if Consulta.confirmado consulta then do
                        putStrLn "Consulta já confirmada"
                        threadDelay 2000000
                        menuPaciente idPac dados
                    else do
                        confirmaConsulta idPac idConsulta dados

            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                verAgendamento idPac dados
        menuPaciente idPac dados
    else if toUpper (head op) == 'N' then do
        menuPaciente idPac dados
    else do
        putStrLn "Opção inválida"
        verAgendamento idPac dados


confirmaConsulta :: Int -> Int -> BD.BD -> IO()
confirmaConsulta idPac idConsulta dados = do
    putStrLn "Deseja [C]onfirmar ou [D]esmarcar a consulta? > "
    op <- prompt "Opção > "
    if toUpper (head op) == 'C' then do
        let consultas = map (\consulta -> if Consulta.idConsulta consulta == idConsulta then consulta { Consulta.confirmado = True } else consulta) (BD.consultas dados)
        let bdAtualizado = dados { BD.consultas = consultas }
        BD.limpaArquivo "Haskell/Persistence/consultas.txt"
        BD.escreveNoArquivoSemContra "Haskell/Persistence/consultas.txt" (BD.consultasToString (BD.consultas bdAtualizado) "")
        putStrLn "Consulta confirmada com sucesso!"
        threadDelay 2000000
        menuPaciente idPac bdAtualizado

    else if toUpper (head op) == 'D' then do
        putStrLn "Consulta não confirmada"
        let consultasAtualizadas = filter (\consulta -> Consulta.idConsulta consulta /= idConsulta) (BD.consultas dados)
        let bdAtualizado = dados { BD.consultas = consultasAtualizadas }
        BD.limpaArquivo "Haskell/Persistence/consultas.txt"
        BD.escreveNoArquivoSemContra "Haskell/Persistence/consultas.txt" (BD.consultasToString (BD.consultas bdAtualizado) "")
        threadDelay 2000000
        menuPaciente idPac bdAtualizado
    else do
        putStrLn "Opção inválida"
        confirmaConsulta idPac idConsulta dados

inicialClinica :: BD.BD -> IO()
inicialClinica dados = do
    limpaTela
    putStrLn (tituloI "CLÍNICA")
    putStrLn (escolheLogin)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'C' then do
        cadastraClinica dados
    else if toUpper (head op2) == 'L' then do
        loginClinica dados
    else if toUpper (head op2) == 'V' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        inicialClinica dados

cadastraClinica :: BD.BD -> IO()
cadastraClinica dados = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE CLÍNICA")
    dadosC <- leituraDadosClinica

    putStrLn ("Clínica cadastrado com sucesso! Seu id é: " ++ (show (BD.idAtualClinica dados)))
    threadDelay 2000000  -- waits for 1 second

    let clinica = CControl.criaClinica (BD.idAtualClinica dados) dadosC
    BD.escreveNoArquivo "Haskell/Persistence/clinicas.txt" (Clinica.toString clinica)

    loginClinica dados { BD.clinicas = (BD.clinicas dados) ++ [clinica],
                         BD.idAtualClinica = (BD.idAtualClinica dados) + 1}

loginClinica :: BD.BD -> IO()
loginClinica dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE CLÍNICA")
    idStr <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""

    case readMaybe idStr :: Maybe Int of
        Just id -> do
            let aut = Autenticator.autenticaClinica (BD.clinicas dados) id senha
            if aut then do
                menuClinica id dados
            else do
                putStrLn "ID ou senha incorretos"
                threadDelay 1000000
                inicialClinica dados
        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            inicialClinica dados

menuClinica :: Int -> BD.BD -> IO()
menuClinica idC dados = do
    let clinica = CControl.getClinicaById idC (BD.clinicas dados)
    if (head (Clinica.metodoAgendamento clinica) == 'A') then do
        menuClinicaA idC dados
    else do
        menuClinicaO idC dados

menuClinicaA :: Int -> BD.BD -> IO()
menuClinicaA idC dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinicaA)

    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        cadastraMedico idC dados
    else if toUpper (head op) == 'V' then do
        visualizaInformacaoClinica idC dados
    else if toUpper (head op) == 'D' then do
        dashBoardC idC dados
    else if toUpper (head op) == 'S' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        menuClinicaA idC dados

menuClinicaO :: Int -> BD.BD -> IO()
menuClinicaO idC dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinicaO)

    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        cadastraMedico idC dados

    else if toUpper (head op) == 'F' then do
        filaVirtualClinica idC dados
    else if toUpper (head op) == 'V' then do
        visualizaInformacaoClinica idC dados
    else if toUpper (head op) == 'D' then do
        dashBoardC idC dados
    else if toUpper (head op) == 'S' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        menuClinicaO idC dados

filaVirtualClinica :: Int -> BD.BD -> IO()
filaVirtualClinica idC dados = do
    limpaTela
    putStrLn (tituloI "FILA VIRTUAL")
    putStrLn (filaVirtualC)
    let filasC = filter (\fila -> Fila.idClinica fila == idC) (BD.filas dados)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        idMStr <- prompt "ID do Médico > "
        case readMaybe idMStr :: Maybe Int of
            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                threadDelay 2000000
                filaVirtualClinica idC dados
            Just idM -> do
                let idM = read idMStr :: Int
                if notElem idM (map Medico.id (BD.medicos dados)) then do
                    putStrLn "ID do Médico não cadastrado"
                    threadDelay 2000000
                    filaVirtualClinica idC dados
                else do
                    let medicosC = BD.filtraMedicosDaClinica dados idC
                    if notElem idM (map Medico.id medicosC) then do
                        putStrLn "ID do Médico não pertence a Clínica"
                        threadDelay 2000000
                        filaVirtualClinica idC dados
                    else do
                        if notElem idM (map Fila.idMedico (BD.filas dados)) then do
                            putStrLn ("Fila criada com sucesso! O id da fila é: " ++ (show (BD.idAtualFila dados)))
                            threadDelay 2000000
                            let fila = CControl.criarFilaVirtual (BD.idAtualFila dados) idC idM
                            BD.escreveNoArquivo "Haskell/Persistence/filas.txt" (Fila.toString fila)
                            menuClinica idC dados { BD.filas = (BD.filas dados) ++ [fila],
                                                    BD.idAtualFila = (BD.idAtualFila dados) + 1 }
                        else do
                            putStrLn "Fila já criada"
                            threadDelay 2000000
                            menuClinica idC dados

    else if toUpper (head op) == 'V' then do
        putStrLn (CControl.verFilasClinica idC (BD.filas dados))
        prompt "Pressione Enter para voltar"
        menuClinica idC dados

    else if toUpper (head op) == 'A' then do
        idFStr <- prompt "ID da Fila > "
        case readMaybe idFStr :: Maybe Int of
            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                threadDelay 2000000
                filaVirtualClinica idC dados
            Just idF -> do
                if notElem idF (map Fila.id (BD.filas dados)) then do
                    putStrLn "ID da Fila não cadastrado"
                    threadDelay 2000000
                    filaVirtualClinica idC dados
                else do
                    if notElem idF (map Fila.id filasC) then do
                        putStrLn "ID da Fila não pertence a Clínica"
                        threadDelay 2000000
                        filaVirtualClinica idC dados
                    else do
                        let idF = read idFStr :: Int
                        let bdAtualizado = atualizaFilaClinica idF dados
                        if not (null (Fila.fila (head (filter (\fila -> Fila.id fila == idF) (BD.filas bdAtualizado))))) then do
                            putStrLn ("Paciente chamado com sucesso! Fila Atualizada!")

                            BD.limpaArquivo "Haskell/Persistence/filas.txt"
                            BD.escreveNoArquivoSemContra "Haskell/Persistence/filas.txt" (BD.filasToString (BD.filas bdAtualizado) "")

                            threadDelay 2000000
                            menuClinica idC bdAtualizado
                        else do
                            putStrLn "Fila vazia"
                            threadDelay 2000000
                            menuClinica idC dados

    else if toUpper (head op) == 'D' then do
        idFStr <- prompt "ID da Fila > "
        case readMaybe idFStr :: Maybe Int of
            Nothing -> do
                putStrLn "ID deve ser um inteiro"
                threadDelay 2000000
                filaVirtualClinica idC dados
            Just idF -> do
                if notElem idF (map Fila.id (BD.filas dados)) then do
                    putStrLn "ID da Fila não cadastrado"
                    threadDelay 2000000
                    filaVirtualClinica idC dados
                else do
                    if notElem idF (map Fila.id filasC) then do
                        putStrLn "ID da Fila não pertence a Clínica"
                        threadDelay 2000000
                        filaVirtualClinica idC dados
                    else do
                        let idF = read idFStr :: Int
                        let bdAtualizado = deletarFilaVirtual idF dados
                        threadDelay 1000000
                        BD.limpaArquivo "Haskell/Persistence/filas.txt"
                        BD.escreveNoArquivoSemContra "Haskell/Persistence/filas.txt" (BD.filasToString (BD.filas bdAtualizado) "")
                        putStrLn ("Fila deletada com sucesso!")
                        threadDelay 2000000
                        menuClinica idC bdAtualizado

    else if toUpper (head op) == 'S' then do
        menuClinica idC dados

    else do
        putStrLn "Opção inválida"
        filaVirtualClinica idC dados

deletarFilaVirtual :: Int -> BD.BD -> BD.BD
deletarFilaVirtual idF dados = do
    let filasAtualizadas = filter (\fila -> Fila.idClinica fila /= idF) (BD.filas dados)
    let bdAtualizado = dados { BD.filas = filasAtualizadas }
    bdAtualizado

atualizaFilaClinica :: Int -> BD.BD -> BD.BD
atualizaFilaClinica idF dados = do
    let filasAtualizadas = map (\filaP -> if idF == (Fila.id filaP) then
                                            atualizarFila filaP
                                            else filaP) (BD.filas dados)
        bdAtualizado = dados { BD.filas = filasAtualizadas }
    bdAtualizado

atualizarFila :: Fila.Fila -> Fila.Fila
atualizarFila fila = fila { Fila.fila = tail (Fila.fila fila)}


dashBoardC :: Int -> BD.BD -> IO()
dashBoardC idC dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (CControl.dashboardC idC (BD.medicos dados) (BD.consultas dados) (BD.clinicas dados))
    prompt "Pressione Enter para voltar"
    menuClinica idC dados

visualizaInformacaoClinica :: Int -> BD.BD -> IO()
visualizaInformacaoClinica idC dados = do
    limpaTela
    putStrLn (tituloI "INFORMAÇÕES DA CLÍNICA")
    putStrLn (visualizarInformacaoClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'A' then do
        visualizaConsultas idC dados

    else if toUpper (head op) == 'P' then do
        visualizaPacientes idC dados

    else if toUpper (head op) == 'M' then do
        visualizaMedicos idC dados

    else if toUpper (head op) == 'V' then do
        menuClinica idC dados

    else do
        putStrLn "Opção inválida"
        visualizaInformacaoClinica idC dados

visualizaConsultas :: Int -> BD.BD -> IO()
visualizaConsultas idC dados = do
    limpaTela
    putStrLn (tituloI "CLÍNICA - CONSULTAS")
    putStrLn (CControl.verConsultas idC (BD.consultas dados))
    prompt "Pressione Enter para voltar"
    menuClinica idC dados

visualizaPacientes :: Int -> BD.BD -> IO()
visualizaPacientes idC dados = do
    limpaTela
    putStrLn (tituloI "CLÍNICA - PACIENTES")
    putStrLn (CControl.verPaciente idC (BD.consultas dados) (BD.pacientes dados))
    prompt "Pressione Enter para voltar"
    menuClinica idC dados

visualizaMedicos :: Int -> BD.BD -> IO()
visualizaMedicos idC dados = do
    limpaTela
    putStrLn (tituloI "CLÍNICA - MÉDICOS")
    putStrLn (CControl.verMedico idC (BD.medicos dados))
    prompt "Pressione Enter para voltar"
    menuClinica idC dados

cadastraMedico :: Int -> BD.BD -> IO()
cadastraMedico idClinica dados = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE MÉDICO")
    dadosM <- leituraDadosMedico
    dadosM <- return (dadosM ++ ["0.0"])
    putStrLn ("Médico cadastrado com sucesso! O id é: " ++ (show (BD.idAtualMedico dados)))

    let medico = CControl.criaMedico idClinica (BD.idAtualMedico dados) dadosM
    BD.escreveNoArquivo "Haskell/Persistence/medicos.txt" (Medico.toString medico)
    threadDelay 2000000  -- waits for 1 second

    menuClinica idClinica dados { BD.medicos = (BD.medicos dados) ++ [medico],
                                  BD.idAtualMedico = (BD.idAtualMedico dados) + 1}

inicialMedico :: BD.BD -> IO()
inicialMedico dados = do
    limpaTela
    putStrLn (tituloI "MÉDICO")
    putStrLn (escolheLoginMedico)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'L' then do
        loginMedico dados
    else if toUpper (head op2) == 'V' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        inicialMedico dados

loginMedico :: BD.BD -> IO()
loginMedico dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE MÉDICO")
    idStr <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""

    case readMaybe idStr :: Maybe Int of
        Just id -> do
            let aut = Autenticator.autenticaMedico (BD.medicos dados) id senha
            if aut then do
                menuMedico id dados
            else do
                putStrLn "ID ou senha incorretos"
                threadDelay 1000000
                inicialMedico dados
        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            inicialMedico dados

menuMedico :: Int  -> BD.BD -> IO()
menuMedico idM dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD MÉDICO")
    putStrLn (dashboardMedico)
    op <- prompt "Opção > "

    if toUpper (head op) == 'V' then do
        verAgendamentoM idM dados

    else if toUpper (head op) == 'E' then do
        emitirM idM dados
    else if toUpper (head op) == 'S' then do
        inicial dados
    else if toUpper (head op) == 'C' then do
        chatsMed idM dados
    else do
        putStrLn "Opção inválida"
        menuMedico idM dados

chatsMed :: Int -> BD.BD -> IO()
chatsMed idMed dados = do
    limpaTela
    putStrLn (tituloI "CHAT MÉDICO")
    putStrLn (chatM)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        criarChatM idMed dados

    else if toUpper (head op) == 'V' then do
        visualizaTodosChatsMed idMed dados

    else if toUpper (head op) == 'A' then do
        abrirConversaMed idMed dados

    else if toUpper (head op) == 'S' then do
        menuMedico idMed dados

    else do
        putStrLn "Opção inválida"
        chatsMed idMed dados

criarChatM :: Int -> BD.BD -> IO()
criarChatM idMed dados = do
    limpaTela
    putStrLn (tituloI "MANDAR MENSAGEM")
    idPStr <- prompt "Id do Paciente > "

    let consultas = BD.filtraConsultasDoMedico dados idMed

    case readMaybe idPStr :: Maybe Int of
        Just idPac -> do
            if notElem idPac (map Consulta.idPaciente consultas) then do
                putStrLn "Você não possui consulta com esse paciente!"
                threadDelay 1000000
                chatsMed idPac dados
            else do
                mensagem <- prompt "Mensagem > "
                putStrLn ("Mensagem enviada com sucesso! O id da sua mensagem é: " ++ (show (BD.idAtualChat dados)))
                threadDelay 2000000
                let chat = ChatControl.criarChat (BD.idAtualChat dados) idPac idMed ("M: " ++ mensagem)

                BD.escreveNoArquivo "Haskell/Persistence/chats.txt" (Chat.toString chat)
                menuMedico idMed dados { BD.chats = (BD.chats dados) ++ [chat],
                                        BD.idAtualChat = (BD.idAtualChat dados) + 1 }

        Nothing -> do
            putStrLn "Paciente não cadastrado."
            threadDelay 1000000
            chatsMed idMed dados


visualizaTodosChatsMed :: Int -> BD.BD -> IO()
visualizaTodosChatsMed idMed dados = do
    limpaTela
    putStrLn (tituloI "CHATS DO MÉDICO")
    putStrLn (ChatControl.verChatsMedico idMed (BD.chats dados) (BD.pacientes dados))
    prompt "Pressione Enter para voltar"
    menuMedico idMed dados

abrirConversaMed :: Int -> BD.BD -> IO()
abrirConversaMed idMed dados = do
    limpaTela
    putStrLn (tituloI "CHAT MÉDICO")
    idChatStr <- prompt "Id do Chat > "

    let chatsMedico = filter (\chat -> Chat.idMedico chat == idMed) (BD.chats dados)

    case readMaybe idChatStr :: Maybe Int of
        Just idChat -> do
            if notElem idChat (map Chat.id (BD.chats dados)) then do
                putStrLn "ID do Chat inválido"
                threadDelay 1000000
                chatsMed idMed dados
            else do
                if notElem idChat (map Chat.id chatsMedico) then do
                    putStrLn "Chat não pertence ao médico"
                    threadDelay 1000000
                    chatsMed idMed dados
                else do
                    putStrLn (ChatControl.verChatEspecifico idChat (BD.chats dados))
                    op <- prompt "[E]nviar Mensagem ou [S]air > "

                    if toUpper (head op) == 'E' then do
                        mensagem <- prompt "Mensagem > "
                        let dadosA = adicionarMensagemAoChat idChat ("M: " ++ mensagem) dados
                        BD.limpaArquivo "Haskell/Persistence/chats.txt"
                        BD.escreveNoArquivoSemContra "Haskell/Persistence/chats.txt" (BD.chatsToString (BD.chats dadosA))
                        menuMedico idMed dadosA

                    else if toUpper (head op) == 'S' then do
                        menuMedico idMed dados

                    else do
                        putStrLn "Opção inválida"
                        abrirConversaMed idMed dados
        Nothing -> do
            putStrLn "ID deve ser um inteiro"
            threadDelay 1000000
            abrirConversaMed idMed dados
    menuMedico idMed dados  

emitirM :: Int  -> BD.BD -> IO()
emitirM idM dados = do
    limpaTela
    putStrLn (tituloI "EMISSÃO DE DOCUMENTOS")
    putStrLn emissaoMedico
    op <- prompt "Opção > "

    if toUpper (head op) == 'R' then do
        emitirReceita idM dados

    else if toUpper (head op) == 'S' then do
        emitirExame idM dados

    else if toUpper (head op) == 'L' then do
        emitirLaudo idM dados

    else if toUpper (head op) == 'V' then do
        menuMedico idM dados
    else do
        putStrLn "Opção inválida"
        emitirM idM dados

emitirLaudo :: Int -> BD.BD -> IO()
emitirLaudo idM dados = do
    limpaTela
    putStrLn (tituloI "EMISSÃO DE LAUDO")
    idPStr <- prompt "ID do Paciente > "
    case readMaybe idPStr :: Maybe Int of
        Just idP -> do
            let consultas = BD.filtraConsultasDoMedico dados idM
            if notElem idP (map Consulta.idPaciente consultas) then do
                putStrLn "Você não possui consulta com esse paciente!"
                threadDelay 1000000
                emitirM idM dados
            else do
                texto <- prompt "Texto > "

                putStrLn ("Laudo emitido com sucesso! O id do laudo é: " ++ (show (BD.idAtualLaudo dados)))
                threadDelay 2000000  -- waits for 2 seconds

                let laudo = MControl.emiteLaudo (BD.idAtualLaudo dados) idM (read idPStr) texto
                BD.escreveNoArquivo "Haskell/Persistence/laudos.txt" (Laudo.toString laudo)

                menuMedico idM dados { BD.laudos = (BD.laudos dados) ++ [laudo],
                                    BD.idAtualLaudo = (BD.idAtualLaudo dados) + 1 }
        Nothing -> do
            putStrLn "ID do Paciente deve ser um inteiro"
            threadDelay 1000000
            emitirM idM dados

emitirExame :: Int -> BD.BD -> IO()
emitirExame idM dados = do
    limpaTela
    putStrLn (tituloI "SOLICITAÇÃO DE EXAME")
    idPStr <- prompt "ID do Paciente > "
    case readMaybe idPStr :: Maybe Int of
        Just idP -> do
            let consultas = BD.filtraConsultasDoMedico dados idM
            if notElem idP (map Consulta.idPaciente consultas) then do
                putStrLn "Você não possui consulta com esse paciente!"
                threadDelay 1000000
                emitirM idM dados
            else do
                tipo <- prompt "Tipo do Exame > "
                putStrLn ("Solicitação de Exame feita com sucesso! O id da solicitação é: " ++ (show (BD.idAtualExame dados)))
                threadDelay 2000000  -- waits for 2 seconds

                let exame = MControl.solicitaExame (BD.idAtualExame dados) idM (read idPStr) tipo
                BD.escreveNoArquivo "Haskell/Persistence/exames.txt" (Exame.toString exame)

                menuMedico idM dados { BD.exames = (BD.exames dados) ++ [exame],
                                    BD.idAtualExame = (BD.idAtualExame dados) + 1 }
        Nothing -> do
            putStrLn "ID do Paciente deve ser um inteiro"
            threadDelay 1000000
            emitirM idM dados

emitirReceita :: Int -> BD.BD -> IO()
emitirReceita idM dados = do
    limpaTela
    putStrLn (tituloI "EMISSÃO DE RECEITA")
    receitaLeitura <- leituraEmissaoReceita

    let idPStr = (receitaLeitura !! 0)

    case readMaybe idPStr :: Maybe Int of
        Just idP -> do
            let consultas = BD.filtraConsultasDoMedico dados idM
            if notElem idP (map Consulta.idPaciente consultas) then do
                putStrLn "Você não possui consulta com esse paciente!"
                threadDelay 1000000
                emitirM idM dados
            else do
                putStrLn ("Receita emitida com sucesso! O id da receita é: " ++ (show (BD.idAtualReceita dados)))
                threadDelay 2000000  -- waits for 2 seconds

                let receita = MControl.emiteReceita (BD.idAtualReceita dados) idM receitaLeitura
                BD.escreveNoArquivo "Haskell/Persistence/receitas.txt" (Receita.toString receita)

                menuMedico idM dados { BD.receitas = (BD.receitas dados) ++ [receita],
                                    BD.idAtualReceita = (BD.idAtualReceita dados) + 1 }

        Nothing -> do
            putStrLn "ID do Paciente deve ser um inteiro"
            threadDelay 1000000
            emitirM idM dados

verAgendamentoM:: Int -> BD.BD -> IO()
verAgendamentoM idM dados = do
    limpaTela
    putStrLn (tituloI "AGENDAMENTOS")
    let consultas = MControl.acessarConsultas idM (BD.consultas dados)
    imprime consultas
    prompt "Pressione Enter para voltar"
    menuMedico idM dados
