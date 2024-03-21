{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Redundant if" #-}


import App.Util
import qualified Models.DataBase as BD
import qualified Persistence.Persistence as Persistence
import qualified Controllers.PacienteController as PControl
import qualified Controllers.AutenticationController as Autenticator

import Data.Char ( toUpper )
import Control.Concurrent (threadDelay)
import Text.XHtml (menu)
import Control.Monad.RWS.Lazy (MonadState(put))
import System.IO (utf8, hSetEncoding, stdout)
import Data.List (sort)


main :: IO ()
main = do
    dados <- Persistence.carregaTodos
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
        Persistence.encerrar dados
        putStrLn "Saindo..."
        -- | Aqui vai a função que encerra o programa.

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
    senha <- prompt "Senha > "
    putStrLn ("Pacinte cadastrado com sucesso! Seu id é: " ++ (show (BD.idAtualPaciente dados)))
    threadDelay 3000000  -- waits for 1 second

    loginPaciente dados { BD.pacientes = (BD.pacientes dados) ++ [PControl.criaPaciente (BD.idAtualPaciente dados) dadosP],
    BD.loginsPacientes = (BD.loginsPacientes dados) ++ [(BD.idAtualPaciente dados, senha)],
    BD.idAtualPaciente = (BD.idAtualPaciente dados) + 1
    }


loginPaciente :: BD.BD -> IO()
loginPaciente dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE PACIENTE")
    id <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""

    let aut = Autenticator.autentica(BD.loginsPacientes dados) (read id) senha

    if aut then do
        menuPaciente dados
    else do
        putStrLn "ID ou senha incorretos"
        threadDelay 1000000  -- waits for 1 second
        inicialPaciente dados


menuPaciente :: BD.BD -> IO()
menuPaciente dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD PACIENTE")
    putStrLn (dashboardPaciente)
    op <- prompt "Opção > "

    if toUpper (head op) == 'M' then do
        menuPaciente dados

    -- | opção Ver Agendamento
    -- | opção Receitas / Laudos / Solicitações de Exames

    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuPaciente dados


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
    senha <- prompt "Senha > "

    putStrLn ("Clínica cadastrado com sucesso! Seu id é: " ++ (show (BD.idAtualClinica dados)))
    threadDelay 2000000  -- waits for 1 second
    
    loginClinica dados { BD.clinicas = (BD.clinicas dados) ++ [CControl.criaClinica (BD.idAtualClinica dados) dadosC],
    BD.loginsClinica = (BD.loginsClinica dados) ++ [(BD.idAtualClinica dados, senha)],
    BD.idAtualClinica = (BD.idAtualClinica dados) + 1
    }

loginClinica :: BD.BD -> IO()
loginClinica dados = do
    limpaTela
    putStrLn (tituloI "LOGIN DE CLÍNICA")
    idC <- prompt "ID > "
    senha <- prompt "Senha > "
    putStrLn ""

    let aut = Autenticator.autentica (BD.loginsClinica dados) (read idC) senha
    if aut then do
        menuClinica dados
    else do
        putStrLn "ID ou senha incorretos"
        threadDelay 1000000  -- waits for 1 second
        inicialClinica dados

menuClinica :: BD.BD -> IO()
menuClinica dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        cadastraMedico 1 dados -- |idClinica na vdd

    else if toUpper (head op) == 'V' then do
        visualizaInformacaoClinica dados
    
    -- | Adicionar opção de abrir o dashboard de analises da clinica

    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuClinica dados

visualizaInformacaoClinica :: BD.BD -> IO()
visualizaInformacaoClinica dados = do
    limpaTela
    putStrLn (tituloI "INFORMAÇÕES DA CLÍNICA")
    putStrLn (visualizarInformacaoClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'A' then do
        menuClinica dados
        -- visualiza agendamentos
    else if toUpper (head op) == 'P' then do
        menuClinica dados
        -- visualiza pacientes
    else if toUpper (head op) == 'M' then do
        menuClinica dados
        -- visualiza medicos
    else if toUpper (head op) == 'V' then do
        menuClinica dados
    
    else do
        putStrLn "Opção inválida"
        visualizaInformacaoClinica dados


cadastraMedico :: Int -> BD.BD -> IO()
cadastraMedico idClinica dados = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE MÉDICO")
    dadosM <- leituraDadosMedico idClinica
    senha <- prompt "Senha > "
    putStrLn "Médico cadastrada com sucesso!"
    threadDelay 1000000  -- waits for 1 second

    -- | Aqui vai a função que verifica se a médico pode ser criado.
    menuClinica dados

inicialMedico :: BD.BD -> IO()
inicialMedico dados = do
    limpaTela
    putStrLn (tituloI "MÉDICO")
    putStrLn (escolheLoginMedico)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'L' then do
        loginMedico
    else if toUpper (head op2) == 'V' then do
        inicial dados
    else do
        putStrLn "Opção inválida"
        inicialMedico dados

loginMedico :: IO()
loginMedico = do
    limpaTela
    putStrLn (tituloI "LOGIN DE MÉDICO")
    crm <- prompt "CRM > "
    senha <- prompt "Senha > "

    -- | Aqui vai a função que verifica se o médico existe e se a senha está correta.
    -- | Se estiver, direciona pro dashboard/menu de médico, caso não volta pra parte de médico.
    menuMedico 1

menuMedico :: Int -> IO()
menuMedico dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD MÉDICO")
    putStrLn (dashboardMedico)
    op <- prompt "Opção > "

    if toUpper (head op) == 'V' then do
        menuMedico 1

    -- | opção Ver Agendamento  (do médico)
    else if toUpper (head op) == 'E' then do
        menuMedico 1
        -- | opção Emitir (receitas, laudos, solicitação de exames)
    else if toUpper (head op) == 'S' then do
        menuMedico 1

    else do
        putStrLn "Opção inválida"
        menuMedico 1

emitirMedico :: IO()
emitirMedico = do
    putStrLn emissaoMedico
    op <- prompt "Opção > "

    if toUpper (head op) == 'R' then do
        menuMedico 1
        -- | opção Receita
    else if toUpper (head op) == 'S' then do
        menuMedico 1
        -- | opção Solicitação de Exame
    else if toUpper (head op) == 'L' then do
        menuMedico 1
        -- | opção Laudo Médico
    else do
        putStrLn "Opção inválida"
        emitirMedico