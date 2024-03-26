{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Redundant if" #-}
{-# LANGUAGE OverloadedStrings #-}

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

import Data.Time
import Data.Char ( toUpper )
import Control.Concurrent (threadDelay)
import Control.Monad.RWS.Lazy (MonadState(put))
import System.IO
import System.Directory
import System.Process (system)
import Data.List (sort)
import GHC.RTS.Flags (MiscFlags(disableDelayedOsMemoryReturn))
import qualified Haskell.Controllers.ChatController as PControl
import Haskell.Models.BD (BD(idAtualPaciente))
import Haskell.Models.Avaliacao (Avaliacao(idPac))
import Data.Text.Internal.Read (IParser(P))



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
        threadDelay 1000000  -- waits for 1 second

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
    threadDelay 2000000  -- waits for 2 seconds

    let paciente = PControl.criaPaciente (BD.idAtualPaciente dados) dadosP
    BD.escreveNoArquivo "Haskell/Persistence/pacientes.txt" (Paciente.toString paciente)

    loginPaciente dados { BD.pacientes = (BD.pacientes dados) ++ [paciente],
                          BD.idAtualPaciente = (BD.idAtualPaciente dados) + 1 }
    inicialPaciente dados


loginPaciente :: BD.BD -> IO()
loginPaciente dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE PACIENTE")
    id <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""
    
    let aut = Autenticator.autenticaPaciente (BD.pacientes dados) (read id) senha
    if aut then do
        menuPaciente (read id) dados
    else do
        putStrLn "ID ou senha incorretos"
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
    -- | opção Receitas / Laudos / Solicitações de Exames

    else if toUpper (head op) == 'A' then do
        cadastraAvaliacao idPac dados

    else if toUpper (head op) == 'S' then do
        inicial dados

    else if toUpper (head op) == 'C' then do
        chatsPac idPac dados

    else do
        putStrLn "Opção inválida"
        menuPaciente idPac dados

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
    nomeMedico <- prompt "Nome do Médico > "
    mensagem <- prompt "Mensagem > "

    putStrLn ("Mensagem enviada com sucesso! O id da sua mensagem é: " ++ (show (BD.idAtualChat dados)))
    threadDelay 2000000

    let idMedico = (MControl.getMedicoId nomeMedico (BD.medicos dados))
    let chat = ChatControl.criarChat (BD.idAtualChat dados) idPac idMedico ("P: " ++ mensagem)
    
    BD.escreveNoArquivo "Haskell/Persistence/chats.txt" (Chat.toString chat)
    menuPaciente idPac dados { BD.chats = (BD.chats dados) ++ [chat],
                          BD.idAtualChat = (BD.idAtualChat dados) + 1 }


visualizaTodosChatsPac :: Int -> BD.BD -> IO()
visualizaTodosChatsPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHATS DO PACIENTE")
    imprime (ChatControl.verChatsPaciente idPac (BD.chats dados) (BD.medicos dados))
    prompt "Pressione Enter para voltar"
    menuPaciente idPac dados

abrirConversaPac :: Int -> BD.BD -> IO()
abrirConversaPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHAT PACIENTE")
    idChatStr <- prompt "Id do Chat >"
    let idChat = read idChatStr :: Int
    putStrLn (ChatControl.verChatEspecifico idChat (BD.chats dados))
    op <- prompt "[R]esponder ou [S]air > "

    if toUpper (head op) == 'R' then do
        mensagem <- prompt "Mensagem > "
        adicionarMensagemAoChat idChat mensagem dados
    
    else if toUpper (head op) == 'S' then do
        menuPaciente idPac dados

    else do
        putStrLn "Opção inválida"
        abrirConversaPac idPac dados
    menuPaciente idPac dados

adicionarMensagemAoChat :: Int -> String -> BD.BD -> IO ()
adicionarMensagemAoChat chatId novaMensagem dados = do
    let chatsAtualizados = map (\chat -> if chatId == Chat.id chat then adicionarMensagem chat novaMensagem else chat) (BD.chats dados)
    let bdAtualizado = dados { BD.chats = chatsAtualizados }
    threadDelay 5000000
    BD.escreveNoArquivo "Haskell/Persistence/chats.txt" (BD.chatsToString (BD.chats bdAtualizado))

-- Função para adicionar uma mensagem a um chat
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
    prompt "Pressione Enter para voltar"
    menuPaciente idPac dados


buscar :: Int -> BD.BD -> IO()
buscar idPac dados = do
    limpaTela
    putStrLn (tituloI "BUSCAR")
    putStrLn (dashboardBuscaMedico)
    op <- prompt "Opção > "

    if toUpper (head op) == 'M' then do
        nomeMedico <- prompt "Nome do Médico > "
        let medicos = PControl.filtrarPorMedico nomeMedico (BD.medicos dados)
        imprime medicos
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'C' then do
        nomeClinica <- prompt "Nome da Clínica > "
        let clinicas = PControl.filtrarPorClinica nomeClinica (BD.clinicas dados)
        imprime clinicas
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'P' then do
        plano <- prompt "Plano de Saúde ou Particular > "
        let clinicas = PControl.filtrarClinicasPorPlanoDeSaude plano (BD.clinicas dados)
        imprime clinicas
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    {-
    else if toUpper (head op) == 'H' then do
        horario <- prompt "Horário > "
        putStrLn (PControl.buscarHorario horario (BD.consultas dados))
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    -}

    else if toUpper (head op) == 'E' then do
        especialidade <- prompt "Especialidade > "
        let medicos = PControl.filtrarMedicosPorEspecialidade especialidade (BD.medicos dados)
        imprime medicos
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    
    else if toUpper (head op) == 'T' then do
        tipo <- prompt "Tipo do Agendamento ( (A)gendamento ou (O)rdem de Chegada ) > "
        let clinicas = PControl.filtrarClinicasPorAgendamento tipo (BD.clinicas dados)
        imprime clinicas
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    
    {-
    else if toUpper (head op) == 'A' then do
        acima <- prompt "Avaliação acima de (0-10) > "
        putStrLn (PControl.filtrarClinicasPorAvaliacao acima (BD.clinicas dados))
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    -}

    else if toUpper (head op) == 'S' then do
        sintoma <- prompt "Sintoma > "
        let medicos = PControl.filtrarMedicoPorSintoma sintoma (BD.medicos dados)
        imprime medicos
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'V' then do
        menuPaciente idPac dados
    else do
        putStrLn "Opção inválida"
        buscar idPac dados


-- É NECESSARIA A IMPLEMENTAÇÃO DESSA FUNÇÃO E RESOLVER COMO IMPLEMENTAR 
-- O LOCAL TIME E O LOCAL DATE (essas funcoes estao no fim do arquivo)
-- ACREDITO QUE POSSA SER DIRETAMENTE AQUI NO MAIN UMA VEZ QUE SE TRATA DE UMA FUNCAO IO. 
-- POR ENQUANTO VOU DEIXAR AQUI COMENTADO


cadastraAvaliacao :: Int -> BD.BD -> IO ()
cadastraAvaliacao idPac dados = do
    limpaTela
    putStrLn (tituloI "AVALIAÇÃO DE ATENDIMENTO")
    dadosAval <- leituraDadosAvaliacao

    putStrLn ("Avaliação cadastrada com sucesso! Seu id é: " ++ (show (BD.idAtualAvaliacao dados)))
    threadDelay 2000000

    let dadosA = [show idPac] ++ dadosAval
    let avaliacao = PControl.criaAvaliacao (BD.idAtualAvaliacao dados) (dadosA)


    BD.escreveNoArquivo "Haskell/Persistence/avaliacoes.txt" (Avaliacao.toString avaliacao)

    menuPaciente idPac dados { BD.avaliacoes = (BD.avaliacoes dados) ++ [avaliacao],
                          BD.idAtualAvaliacao = (BD.idAtualAvaliacao dados) + 1 }
   

cadastraConsulta :: Int -> BD.BD -> IO()
cadastraConsulta idPac dados = do
    limpaTela
    putStr (tituloI "AGENDAMENTO DE CONSULTA")
    idC <- prompt "ID da Clínica > "
    idM <- prompt "ID do Médico > "
    dia <- prompt "Data da Consulta > "
    putStrLn "\nHorários disponíveis: \n"
    let horarios = BD.horariosDisponiveis dados (read idM) dia
    imprime horarios

    horario <- prompt "Horário > "

    putStrLn ("Consulta marcada com sucesso! o id da consulta é: " ++ (show (BD.idAtualConsulta dados)))
    threadDelay 2000000

    let dadosCons = [show idPac, idC, idM, dia, horario]
    let consulta = PControl.criaConsulta (BD.idAtualConsulta dados) (dadosCons)
    BD.escreveNoArquivo "Haskell/Persistence/consultas.txt" (Consulta.toString consulta)

    menuPaciente idPac dados { BD.consultas = (BD.consultas dados) ++ [consulta],
                               BD.idAtualConsulta = (BD.idAtualConsulta dados) + 1 }


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
    idC <- prompt "ID > "
    senha <- prompt "Senha > "

    let aut = Autenticator.autenticaClinica (BD.clinicas dados) (read idC) senha
    if aut then do
        menuClinica (read idC) dados
    else do
        putStrLn "ID ou senha incorretos"
        threadDelay 1000000  -- waits for 1 second
        inicialClinica dados

menuClinica :: Int -> BD.BD -> IO()
menuClinica idC dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        cadastraMedico idC dados

    else if toUpper (head op) == 'V' then do
        visualizaInformacaoClinica idC dados
    
    -- | Adicionar opção de abrir o dashboard de analises da clinica
    else if toUpper (head op) == 'D' then do
        dashBoardC idC dados
    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuClinica idC dados

dashBoardC :: Int -> BD.BD -> IO()
dashBoardC idC dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (CControl.dashboardC idC (BD.medicos dados) (BD.consultas dados))
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

    putStrLn ("Médico cadastrado com sucesso! O id é: " ++ (show (BD.idAtualMedico dados)))

    let medico = CControl.criaMedico idClinica (BD.idAtualMedico dados) dadosM
    BD.escreveNoArquivo "Haskell/Persistence/medicos.txt" (Medico.toString medico)
    threadDelay 2000000  -- waits for 1 second

    menuClinica idClinica dados { BD.medicos = (BD.medicos dados) ++ [medico],
                                  BD.idAtualMedico = (BD.idAtualMedico dados) + 1}

-- dashboardC :: Int -> BD.BD -> IO()
-- dashboardC idC dados = do
--     limpaTela
--     putStrLn (tituloI "DASHBOARD CLÍNICA")
--     let med = sort (CControl.consultarMedico idC (BD.medicos dados))
--     putStrLn (med)
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
    idM <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""


    let aut = Autenticator.autenticaMedico (BD.medicos dados) (read idM) senha
    if aut then do
        menuMedico (read idM) dados
    else do
        putStrLn "ID ou senha incorretos"
        threadDelay 2000000
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

    else do
        putStrLn "Opção inválida"
        menuMedico idM dados

emitirM :: Int  -> BD.BD -> IO()
emitirM idM dados = do
    limpaTela
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
    idP <- prompt "ID do Paciente > "
    texto <- prompt "Texto > "

    putStrLn ("Laudo emitido com sucesso! O id do laudo é: " ++ (show (BD.idAtualLaudo dados)))
    threadDelay 2000000  -- waits for 2 seconds

    let laudo = MControl.emiteLaudo (BD.idAtualLaudo dados) idM (read idP) texto
    BD.escreveNoArquivo "Haskell/Persistence/laudos.txt" (Laudo.toString laudo)

    menuMedico idM dados { BD.laudos = (BD.laudos dados) ++ [laudo],
                          BD.idAtualLaudo = (BD.idAtualLaudo dados) + 1 }

emitirExame :: Int -> BD.BD -> IO()
emitirExame idM dados = do
    limpaTela
    putStrLn (tituloI "SOLICITAÇÃO DE EXAME")
    idP <- prompt "ID do Paciente > "
    tipo <- prompt "Tipo do Exame > "
    dia <- prompt "Dia do Exame > "

    putStrLn ("Solicitação de Exame feita com sucesso! O id da solicitação é: " ++ (show (BD.idAtualExame dados)))
    threadDelay 2000000  -- waits for 2 seconds

    let exame = MControl.solicitaExame (BD.idAtualExame dados) idM (read idP) tipo dia
    BD.escreveNoArquivo "Haskell/Persistence/exames.txt" (Exame.toString exame)

    menuMedico idM dados { BD.exames = (BD.exames dados) ++ [exame],
                          BD.idAtualExame = (BD.idAtualExame dados) + 1 }

emitirReceita :: Int -> BD.BD -> IO()
emitirReceita idM dados = do
    limpaTela
    putStrLn (tituloI "EMISSÃO DE RECEITA")
    receitaLeitura <- leituraEmissaoReceita

    putStrLn ("Receita emitida com sucesso! O id da receita é: " ++ (show (BD.idAtualReceita dados)))
    threadDelay 2000000  -- waits for 2 seconds

    let receita = MControl.emiteReceita (BD.idAtualReceita dados) idM receitaLeitura
    BD.escreveNoArquivo "Haskell/Persistence/receitas.txt" (Receita.toString receita)

    menuMedico idM dados { BD.receitas = (BD.receitas dados) ++ [receita],
                          BD.idAtualReceita = (BD.idAtualReceita dados) + 1 }

verAgendamentoM:: Int -> BD.BD -> IO()
verAgendamentoM idM dados = do
    limpaTela
    putStrLn (tituloI "AGENDAMENTOS")
    let consultas = MControl.acessarConsultas idM (BD.consultas dados)
    imprime consultas
    prompt "Pressione Enter para voltar"
    menuMedico idM dados

-- Funcoes para capturar a data e hora atual

obterDataHoraAtual :: IO String
obterDataHoraAtual = do
    currentTime <- getCurrentTime
    let timeZone = hoursToTimeZone (-3) 
        localTime = utcToLocalTime timeZone currentTime
    return $ formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S" localTime