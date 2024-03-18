module Util where

import System.Process
import System.IO (stdout, hFlush)

titulo :: String
titulo = " -------------------------------------------------\n"
       ++" ------------------- EVERCARE --------------------\n"
       ++" -------------------------------------------------\n"

tituloI :: String -> String
tituloI t = " -------------------------------------------------\n"
            ++" ----------- EVERCARE - " ++ t ++ " -----------\n"
            ++" -------------------------------------------------\n"

escolheEntidade :: String
escolheEntidade = " -----------------------------\n"
              ++" [P] - Paciente\n"
              ++" [C] - Clínica\n"
              ++" [M] - Médico\n"
              ++" [S] - Sair\n"
              ++" ---------------------------\n"

escolheLogin :: String
escolheLogin = " -----------------------------\n"
        ++" [C] - Cadastrar\n"
        ++" [L] - Login\n"
        ++" [V] - Voltar\n"
        ++" ---------------------------\n"

escolheLoginMedico :: String
escolheLoginMedico = " -----------------------------\n"
                   ++" [L] - Login\n"
                   ++" [V] - Voltar\n"
                   ++" ---------------------------\n"


leituraDadosPaciente :: IO [String]
leituraDadosPaciente = do
    sequence [prompt "Nome > ",
              prompt "CPF > ",
              prompt "Data de Nascimento > ",
              prompt "Peso > ",
              prompt "Altura > ",
              prompt "Tipo Sanguineo > ",
              prompt "Endereço > "]

dashboardPaciente :: String
dashboardPaciente =   " [M] - Marcar Consultas\n"
                    ++" [V] - Ver Agendamentos\n"
                    ++" [S] - Sair\n"

leituraDadosClinica :: IO [String]
leituraDadosClinica = do
    sequence [prompt "Nome > ",
              prompt "CNPJ > ",
              prompt "Endereço > "]

dashboardClinica :: String
dashboardClinica = " [C] - Cadastrar Médico\n"
                 ++" [V] - Ver Médicos\n"
                 ++" [S] - Sair\n"

leituraDadosMedico :: Int -> IO [String]
leituraDadosMedico idClinica = do
    sequence [prompt "Nome > ",
              prompt "CRM > ",
              prompt "Especialidade > ",
              prompt "Horário de atendimento > "] -- | Pensar como fazer aqui.


dashboardMedico :: String
dashboardMedico = " [V] - Ver Agendamentos\n"
                ++" [S] - Sair\n"

-- | Clear the terminal screen
limpaTela :: IO ()
limpaTela = do
    _ <- system "clear"
    return ()

prompt :: String -> IO String
prompt text = do
    putStr text
    hFlush stdout
    getLine