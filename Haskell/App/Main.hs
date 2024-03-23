{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Redundant if" #-}
{-# LANGUAGE OverloadedStrings #-}

import Haskell.App.Util
import qualified Haskell.Models.BD as BD
import qualified Haskell.Controllers.PacienteController as PControl
import qualified Haskell.Controllers.AutenticationController as Autenticator
import qualified Haskell.Controllers.ClinicaController as CControl
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico

import Data.Char ( toUpper )
import Control.Concurrent (threadDelay)
import Text.XHtml (menu)
import Control.Monad.RWS.Lazy (MonadState(put))
import System.IO
import System.Directory
import System.Process (system)
import Data.List (sort)


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

    if toUpper (head op) == 'M' then do
        menuPaciente idPac dados

    -- | opção Ver Agendamento
    -- | opção Receitas / Laudos / Solicitações de Exames

    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuPaciente idPac dados


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

    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuClinica idC dados

visualizaInformacaoClinica :: Int -> BD.BD -> IO()
visualizaInformacaoClinica idC dados = do
    limpaTela
    putStrLn (tituloI "INFORMAÇÕES DA CLÍNICA")
    putStrLn (visualizarInformacaoClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'A' then do
        menuClinica idC dados
        -- visualiza agendamentos
    else if toUpper (head op) == 'P' then do
        menuClinica idC dados
        -- visualiza pacientes
    else if toUpper (head op) == 'M' then do
        menuClinica idC dados
        -- visualiza medicos
    else if toUpper (head op) == 'V' then do
        menuClinica idC dados
    
    else do
        putStrLn "Opção inválida"
        visualizaInformacaoClinica idC dados


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
        menuMedico idM dados

    -- | opção Ver Agendamento  (do médico)
    else if toUpper (head op) == 'E' then do
        menuMedico idM dados
        -- | opção Emitir (receitas, laudos, solicitação de exames)
    else if toUpper (head op) == 'S' then do
        inicial dados

    else do
        putStrLn "Opção inválida"
        menuMedico idM dados

emitirMedico :: Int  -> BD.BD -> IO()
emitirMedico idM dados = do
    putStrLn emissaoMedico
    op <- prompt "Opção > "

    if toUpper (head op) == 'R' then do
        menuMedico idM dados
        -- | opção Receita
    else if toUpper (head op) == 'S' then do
        menuMedico idM dados
        -- | opção Solicitação de Exame
    else if toUpper (head op) == 'L' then do
        menuMedico idM dados
        -- | opção Laudo Médico
    else do
        putStrLn "Opção inválida"
        emitirMedico idM dados