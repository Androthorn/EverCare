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
              prompt "Sexo > ",
              prompt "Data de Nascimento > ",
              prompt "Endereço > ",
              prompt "Peso > ",
              prompt "Altura > ",
              prompt "Tipo Sanguineo > ",
              prompt "Cardiopata (S ou N) > ",
              prompt "Hipertenso (S ou N) > ",
              prompt "Diabético (S ou N) > "]

dashboardPaciente :: String
dashboardPaciente =   " [M] - Marcar Consultas\n"
                    ++" [V] - Ver Agendamentos\n"
                    ++" [R] - Receitas / Laudos / Solicitação de Exames\n"
                    ++" [S] - Sair\n"

leituraDadosClinica :: IO [String]
leituraDadosClinica = do
    sequence [prompt "Nome > ",
              prompt "CNPJ > ",
              prompt "Endereço > ",
              prompt "Planos Vinculados > ",
              prompt "Horários de Funcionamento > ",
              prompt "Contato > "]

dashboardClinica :: String
dashboardClinica = " [C] - Cadastrar Médico\n"
                 ++" [V] - Ver Informações\n"
                 ++" [D] - Dashboard\n"
                 ++" [S] - Sair\n"

visualizarInformacaoClinica :: String
visualizarInformacaoClinica =   " [A] - Agendamentos\n"
                            ++ " [P] - Pacientes\n"
                            ++ " [M] - Médicos\n"
                            ++ " [V] - Voltar\n"


leituraDadosMedico :: Int -> IO [String]
leituraDadosMedico idClinica = do
    sequence [prompt "Nome > ",
              prompt "CRM > ",
              prompt "Especialidade > ",
              prompt "Horário de atendimento > "] -- | Pensar como fazer aqui.


dashboardMedico :: String
dashboardMedico = " [V] - Ver Agendamentos\n"
                ++" [E] - Emitir\n"
                ++" [S] - Sair\n"

emissaoMedico :: String
emissaoMedico = " [R] - Receita\n"
             ++ " [S] - Solicitação de Exame\n"
             ++ " [L] - Laudo Médico\n"

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