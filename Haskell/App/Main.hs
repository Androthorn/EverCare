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
import qualified Haskell.Controllers.ChatController as PControl
import Haskell.Models.BD (BD(idAtualPaciente))
import Haskell.Models.Avaliacao (Avaliacao(idPac))
import Data.Text.Internal.Read (IParser(P))
import GHC.Base (VecElem(Int16ElemRep))
import Text.Read (readMaybe)
import Text.XHtml (menu, th)



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
    -- let random = MControl.atualizaMedias dados
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
        -- MControl.atualizaMedias dados
        menuPaciente idPac dados

    else if toUpper (head op) == 'S' then do
        inicial dados

    else if toUpper (head op) == 'C' then do
        chatsPac idPac dados

    else do
        putStrLn "Opção inválida"
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
        let medicos = BD.filtraMedicoPorEspecialidade dados especialidade
        imprime medicos
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    
    else if toUpper (head op) == 'T' then do
        tipo <- prompt "Tipo do Agendamento ( (A)gendamento ou (O)rdem de Chegada ) > "
        let clinicas = PControl.filtrarClinicasPorAgendamento tipo (BD.clinicas dados)
        imprime clinicas
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    
    
    else if toUpper (head op) == 'A' then do
        acimaStr <- prompt "Avaliação acima de (0-10) > "
        let acimaValor = read acimaStr :: Float
        let medicos = (PControl.filtrarMedicosPorAvaliacoes acimaValor (BD.medicos dados))
        let avaliacoes = map Medico.toStringAval medicos
        putStrLn (unlines avaliacoes)
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados
    

    else if toUpper (head op) == 'S' then do
        sintoma <- prompt "Descreva o que está sentindo > "
        let medicos = BD.filtrarMedicoPorSintoma dados sintoma
        imprime medicos
        prompt "Pressione Enter para voltar"
        menuPaciente idPac dados

    else if toUpper (head op) == 'V' then do
        menuPaciente idPac dados
    else do
        putStrLn "Opção inválida"
        buscar idPac dados

cadastraConsulta :: Int -> BD.BD -> IO()
cadastraConsulta idPac dados = do
    limpaTela
    putStr (tituloI "AGENDAMENTO DE CONSULTA")
    idStrC <- prompt "ID da Clínica > "

    case readMaybe idStrC :: Maybe Int of
        Just idC -> do

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
                            putStrLn ("Consulta marcada com sucesso! o id da consulta é: " ++ (show (BD.idAtualConsulta dados)))
                            threadDelay 2000000

                            let dadosCons = [show idPac, idStrC, idStrM, dia, horario]

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
    limpaTela
    putStrLn (tituloI "AVALIAÇÃO DE ATENDIMENTO")
    dadosAval <- leituraDadosAvaliacao
    let idAvaliacao = BD.idAtualAvaliacao dados
    let idMed = read (head dadosAval) :: Int
    let nota = read (dadosAval !! 1) :: Int
    let notaFloat = fromIntegral nota
    let texto = last dadosAval

    let avaliacao = Avaliacao.Avaliacao idAvaliacao idPac idMed nota texto
    putStrLn ("Avaliação cadastrada com sucesso! O id da sua avaliação é: " ++ (show (BD.idAtualAvaliacao dados)))
    threadDelay 2000000

    timeZoneBR <- getCurrentTimeZone
    currentTime <- getCurrentTime
    let formattedTime = formatTime defaultTimeLocale "%d-%m-%Y %H:%M:%S" (utcToZonedTime timeZoneBR currentTime)

    -- let bdMedicosAtualizados = atualizaBDMedicos idMed notaFloat dados
    -- threadDelay 2000000
    -- BD.limpaArquivo "Haskell/Persistence/medicos.txt"
    -- threadDelay 2000000
    -- BD.escreveNoArquivoSemContra "Haskell/Persistence/medicos.txt" (BD.medicosToString (BD.medicos bdMedicosAtualizados) "")
    BD.escreveNoArquivo "Haskell/Persistence/avaliacoes.txt" (Avaliacao.toString avaliacao ++ ";" ++ formattedTime)

    let bdAtualizado = dados { BD.avaliacoes = avaliacoes ++ [avaliacao],
                                BD.idAtualAvaliacao = (BD.idAtualAvaliacao dados) + 1 }
    let bdMAtualizado = atualizaBDmedicos idMed bdAtualizado

    BD.limpaArquivo "Haskell/Persistence/medicos.txt"
    BD.escreveNoArquivoSemContra "Haskell/Persistence/medicos.txt" (BD.medicosToString (BD.medicos bdMAtualizado) "")

    menuPaciente idPac bdMAtualizado

atualizaBDmedicos :: Int -> BD.BD -> BD.BD
atualizaBDmedicos idMed dados = do
    let medicosAtualizados = MControl.adicionaMedia idMed (BD.avaliacoes dados) (BD.medicos dados)
        bdAtualizado = dados { BD.medicos = medicosAtualizados }
    bdAtualizado

-- atualizaBDMedicos :: Int -> Float -> BD.BD -> BD.BD
-- atualizaBDMedicos idMed novaNota dados = do
--     let medicosAtualizados1 = MControl.atualizaNumAvaliacoesMedico idMed (BD.medicos dados)
--         medicosAtualizados2 = MControl.atualizarMediaNotasMedico idMed novaNota medicosAtualizados1
--         bdAtualizado = dados { BD.medicos = medicosAtualizados2 }
--     bdAtualizado

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
    
    let consultas = BD.filtraConsultasDoPaciente dados idPac

    case MControl.getMedicoId nomeMedico (BD.medicos dados) of
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
    -- imprime(BD.chats dados)
    -- threadDelay 30000000
    putStrLn (ChatControl.verChatsPaciente idPac (BD.chats dados) (BD.medicos dados))
    prompt "Pressione Enter para voltar"
    menuPaciente idPac dados

abrirConversaPac :: Int -> BD.BD -> IO()
abrirConversaPac idPac dados = do
    limpaTela
    putStrLn (tituloI "CHAT PACIENTE")
    idChatStr <- prompt "Id do Chat > "
    let idChat = read idChatStr :: Int
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

    menuPaciente idPac dados

adicionarMensagemAoChat :: Int -> String -> BD.BD -> BD.BD
adicionarMensagemAoChat chatId novaMensagem dados =
    let chatsAtualizados = map (\chat -> if chatId == Chat.id chat then adicionarMensagem chat novaMensagem else chat) (BD.chats dados)
        bdAtualizado = dados { BD.chats = chatsAtualizados }
    -- imprime(BD.chats dados)
    -- threadDelay 10000000
    in do
        bdAtualizado

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


-- É NECESSARIA A IMPLEMENTAÇÃO DESSA FUNÇÃO E RESOLVER COMO IMPLEMENTAR 
-- O LOCAL TIME E O LOCAL DATE (essas funcoes estao no fim do arquivo)
-- ACREDITO QUE POSSA SER DIRETAMENTE AQUI NO MAIN UMA VEZ QUE SE TRATA DE UMA FUNCAO IO. 
-- POR ENQUANTO VOU DEIXAR AQUI COMENTADO


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
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinica)
    -- let random = MControl.atualizaMedias dados

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
    dadosM <- return (dadosM ++ ["-1"])
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
    -- let random = MControl.atualizaMedias dados
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
    nomePac <- prompt "Nome do Paciente > "
    
    let consultas = BD.filtraConsultasDoMedico dados idMed

    case PControl.getPacienteId nomePac (BD.pacientes dados) of
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
    -- imprime(BD.chats dados)
    -- threadDelay 20000000
    putStrLn (ChatControl.verChatsMedico idMed (BD.chats dados) (BD.pacientes dados))
    prompt "Pressione Enter para voltar"
    menuMedico idMed dados

abrirConversaMed :: Int -> BD.BD -> IO()
abrirConversaMed idMed dados = do
    limpaTela
    putStrLn (tituloI "CHAT MÉDICO")
    idChatStr <- prompt "Id do Chat > "
    let idChat = read idChatStr :: Int
    putStrLn (ChatControl.verChatEspecifico idChat (BD.chats dados))
    op <- prompt "[E]nviar Mensagem ou [S]air > "

    if toUpper (head op) == 'E' then do
        mensagem <- prompt "Mensagem > "
        let dadosA = adicionarMensagemAoChat idChat ("P: " ++ mensagem) dados
        BD.limpaArquivo "Haskell/Persistence/chats.txt"
        BD.escreveNoArquivoSemContra "Haskell/Persistence/chats.txt" (BD.chatsToString (BD.chats dadosA))
        menuPaciente idMed dadosA

    else if toUpper (head op) == 'S' then do
        menuMedico idMed dados

    else do
        putStrLn "Opção inválida"
        abrirConversaMed idMed dados

    menuMedico idMed dados

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
