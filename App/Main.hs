{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Redundant if" #-}
module Main where

import Util
import Data.Char ( toUpper )
import Control.Concurrent (threadDelay)
import Text.XHtml (menu)
import Control.Monad.RWS.Lazy (MonadState(put))


main :: IO ()
main = do
    inicial

inicial :: IO ()
inicial = do
    limpaTela
    putStrLn (titulo)
    putStrLn (escolheEntidade)

    op <- prompt "Opção > "
    if toUpper (head op) == 'P' then do
        inicialPaciente
    
    else if toUpper (head op) == 'C' then do
        inicialClinica

    else if toUpper (head op) == 'M' then do
        inicialMedico

    else if toUpper (head op) == 'S' then do
        putStrLn "Saindo..."
        -- | Aqui vai a função que encerra o programa.

    else do
        putStrLn "Opção inválida"
        inicial

inicialPaciente :: IO()
inicialPaciente = do
    limpaTela
    putStrLn (tituloI "PACIENTE")
    putStrLn (escolheLogin)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'C' then do
        cadastraPaciente
    else if toUpper (head op2) == 'L' then do
        loginPaciente
    else if toUpper (head op2) == 'V' then do
        inicial
    else do
        putStrLn "Opção inválida"
        inicialPaciente

cadastraPaciente :: IO()
cadastraPaciente = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE PACIENTE")
    dados <- leituraDadosPaciente
    senha <- prompt "Senha > "
    putStrLn "Paciente cadastrado com sucesso! Direcionando pro Login..."
    threadDelay 1000000  -- waits for 1 second

    -- | Aqui vai a função que salva os dados no banco de dados.
    loginPaciente


loginPaciente :: IO()
loginPaciente = do
    limpaTela
    putStrLn (tituloI "LOGIN DE PACIENTE")
    cpf <- prompt "CPF > "
    senha <- prompt "Senha > "

    -- | Aqui vai a função que verifica se o paciente existe e se a senha está correta.
    -- | Se estiver, direciona pro dashboard/menu de paciente, caso não volta pra parte de paciente.
    menuPaciente 1


menuPaciente :: Int -> IO()
menuPaciente dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD PACIENTE")
    putStrLn (dashboardPaciente)
    op <- prompt "Opção > "

    if toUpper (head op) == 'M' then do
        menuPaciente 1

    -- | opção Ver Agendamento
    -- | opção Receitas / Laudos / Solicitações de Exames

    else if toUpper (head op) == 'S' then do
        inicial

    else do
        putStrLn "Opção inválida"
        menuPaciente 1


inicialClinica :: IO()
inicialClinica = do
    limpaTela
    putStrLn (tituloI "CLÍNICA")
    putStrLn (escolheLogin)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'C' then do
        cadastraClinica
    else if toUpper (head op2) == 'L' then do
        loginClinica
    else if toUpper (head op2) == 'V' then do
        inicial
    else do
        putStrLn "Opção inválida"
        inicialClinica

cadastraClinica :: IO()
cadastraClinica = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE CLÍNICA")
    dados <- leituraDadosClinica
    senha <- prompt "Senha > "
    putStrLn "Clínica cadastrada com sucesso! Direcionando pro Login..."
    threadDelay 1000000  -- waits for 1 second

    -- | Aqui vai a função que salva os dados no banco de dados.
    loginClinica

loginClinica :: IO()
loginClinica = do
    limpaTela
    putStrLn (tituloI "LOGIN DE CLÍNICA")
    cnpj <- prompt "CNPJ > "
    senha <- prompt "Senha > "

    -- | Aqui vai a função que verifica se a clínica existe e se a senha está correta.
    -- | Se estiver, direciona pro dashboard/menu de clínica, caso não volta pra parte de clínica.
    menuClinica 1

menuClinica :: Int -> IO()
menuClinica dados = do
    limpaTela
    putStrLn (tituloI "DASHBOARD CLÍNICA")
    putStrLn (dashboardClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'C' then do
        cadastraMedico 1 -- |idClinica na vdd

    else if toUpper (head op) == 'V' then do
        visualizaInformacaoClinica
    
    -- | Adicionar opção de abrir o dashboard de analises da clinica

    else if toUpper (head op) == 'S' then do
        inicial

    else do
        putStrLn "Opção inválida"
        menuClinica 1

visualizaInformacaoClinica :: IO ()
visualizaInformacaoClinica = do
    limpaTela
    putStrLn (tituloI "INFORMAÇÕES DA CLÍNICA")
    putStrLn (visualizarInformacaoClinica)
    op <- prompt "Opção > "

    if toUpper (head op) == 'A' then do
        menuClinica 1
        -- visualiza agendamentos
    else if toUpper (head op) == 'P' then do
        menuClinica 1
        -- visualiza pacientes
    else if toUpper (head op) == 'M' then do
        menuClinica 1
        -- visualiza medicos
    else if toUpper (head op) == 'V' then do
        menuClinica 1
    
    else do
        putStrLn "Opção inválida"
        visualizaInformacaoClinica


cadastraMedico :: Int -> IO()
cadastraMedico idClinica = do
    limpaTela
    putStrLn (tituloI "CADASTRO DE MÉDICO")
    dados <- leituraDadosMedico idClinica
    senha <- prompt "Senha > "
    putStrLn "Médico cadastrada com sucesso!"
    threadDelay 1000000  -- waits for 1 second

    -- | Aqui vai a função que verifica se a médico pode ser criado.
    menuClinica 1

inicialMedico :: IO()
inicialMedico = do
    limpaTela
    putStrLn (tituloI "MÉDICO")
    putStrLn (escolheLoginMedico)

    op2 <- prompt "Opção > "
    if toUpper (head op2) == 'L' then do
        loginMedico
    else if toUpper (head op2) == 'V' then do
        inicial
    else do
        putStrLn "Opção inválida"
        inicialMedico

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
        inicial

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