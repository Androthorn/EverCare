module Haskell.App.Util where

import System.Process (system)
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)

titulo :: String
titulo = " -------------------------------------------------\n"
       ++" ------------------- EVERCARE --------------------\n"
       ++" -------------------------------------------------\n"

tituloI :: String -> String
tituloI t =
    let numTracos = (37 - length t) `div` 2
        tracos = replicate numTracos '-'
        tracoExtra = if even (length t) then "" else "-"
    in  " -------------------------------------------------\n" ++
        " " ++ tracos ++ " EVERCARE - " ++ t ++ " "  ++  replicate (37 - numTracos - length t - 1) '-' ++ "\n" ++
        " -------------------------------------------------\n"

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
              prompt "Tipo Sanguineo > ",
              prompt "Plano de Saúde > ",
              prompt "Cardiopata (S ou N) > ",
              prompt "Hipertenso (S ou N) > ",
              prompt "Diabético (S ou N) > ",
              prompt "Senha > "]
              
dashboardPaciente :: String
dashboardPaciente =   " [B] - Buscar\n"
                    ++" [M] - Marcar Consultas\n"
                    ++" [V] - Ver Agendamentos\n"
                    ++" [R] - Ver Receitas / Laudos / Solicitação de Exames\n"
                    ++" [A] - Avaliacao de Atendimento\n"
                    ++" [C] - Chats\n"
                    ++" [F] - Fila Virtual\n"
                    ++" [S] - Sair\n"

filaVirtualP :: String
filaVirtualP = " [E] - Entrar em Fila\n"
            ++ " [V] - Ver Fila\n"
            ++ " [S] - Sair\n"

filaVirtualC :: String
filaVirtualC = " [C] - Criar Fila\n"
            ++ " [V] - Ver Filas\n"
            ++ " [A] - Atualizar Fila\n"
            ++ " [D] - Deletar Fila\n"
            ++ " [S] - Sair\n"

chatP :: String
chatP = " [C] - Criar Chat com Médico\n"
      ++" [V] - Ver Chats Ativos\n"
      ++" [A] - Abrir conversa\n"
      ++" [S] - Sair\n"

emissaoPaciente :: String
emissaoPaciente = " [R] - Receita\n"
               ++ " [S] - Solicitação de Exame\n"
               ++ " [L] - Laudo Médico\n"
               ++ " [V] - Voltar\n"

leituraDadosAvaliacao :: IO [String]
leituraDadosAvaliacao = do
    sequence [prompt "Médico > ",
              prompt "Nota (0-10) > ",
              prompt "Comentário > "]

dashboardBusca :: String
dashboardBusca = " [M] - Buscar Médicos\n" 
        ++" [C] - Buscar Clínicas\n"
        ++" [V] - Voltar\n"

dashboardBuscaMedico :: String
dashboardBuscaMedico = " [M] - Nome do Médico\n" 
        ++" [C] - Por Clínica\n"
        ++" [H] - Horário\n"
        ++" [E] - Especialidade\n"
        ++" [A] - Avaliação acima de (0-10)\n"
        ++" [S] - Sintoma\n"
        ++" [V] - Voltar\n"

dashboardBuscaClinica :: String
dashboardBuscaClinica = " [C] - Nome da Clínica\n"
        ++" [P] - Plano de Saúde\n"
        ++" [T] - Tipo de Agendamento\n"
        ++" [V] - Voltar\n"

leituraDadosClinica :: IO [String]
leituraDadosClinica = do
    sequence [prompt "Nome > ",
              prompt "Endereço > ",
              prompt "Planos Vinculados > ",
              prompt "Método de Agendamento [(A)gendamento ou (O)rdem de Chegada] > ",
              prompt "Contato > ",
              prompt "Senha > "]

leituraDadosConsulta :: IO [String]
leituraDadosConsulta = do
    sequence [prompt "Clínica > ",
              prompt "Médico > ",
              prompt "Data da consulta > ",
              prompt "Horário > "]

leituraEmissaoReceita :: IO [String]
leituraEmissaoReceita = do
    sequence [prompt "ID do Paciente > ",
              prompt "Remédios e Instruções > "]

dashboardClinicaA :: String
dashboardClinicaA = " [C] - Cadastrar Médico\n"
                 ++" [V] - Ver Informações\n"
                 ++" [D] - Dashboard\n"
                 ++" [S] - Sair\n"

dashboardClinicaO :: String
dashboardClinicaO = " [C] - Cadastrar Médico\n"
                 ++" [F] - Fila Virtual\n"
                 ++" [V] - Ver Informações\n"
                 ++" [D] - Dashboard\n"
                 ++" [S] - Sair\n"


visualizarInformacaoClinica :: String
visualizarInformacaoClinica =   " [A] - Agendamentos\n"
                            ++ " [P] - Pacientes\n"
                            ++ " [M] - Médicos\n"
                            ++ " [V] - Voltar\n"


leituraDadosMedico :: IO [String]
leituraDadosMedico = do
    sequence [prompt "Nome > ",
              prompt "CRM > ",
              prompt "Especialidade > ",
              prompt "Senha > "]


dashboardMedico :: String
dashboardMedico = " [V] - Ver Agendamentos\n"
                ++" [E] - Emitir\n"
                ++" [C] - Chats\n"
                ++" [S] - Sair\n"

chatM :: String
chatM = " [C] - Criar Chat com Paciente\n"
      ++" [V] - Ver Chats Ativos\n"
      ++" [A] - Abrir conversa\n"
      ++" [S] - Sair\n"

emissaoMedico :: String
emissaoMedico = " [R] - Receita\n"
             ++ " [S] - Solicitação de Exame\n"
             ++ " [L] - Laudo Médico\n"
             ++ " [V] - Voltar\n"

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

boolToString :: Bool -> String
boolToString True = "S"
boolToString False = "N"

split :: String -> Char -> String -> [String]
split "" _ "" = []
split "" _ aux = [aux]
split (h : t) sep aux | h == sep && aux == "" = split t sep aux
                  | h == sep = [aux] ++ split t sep ""
                  | otherwise = split t sep (aux ++ [h])


formataLista :: Show t => [t] -> String
formataLista [] = ""
formataLista (x:xs) = (show x) ++ "\n" ++ (formataLista xs)

imprime :: Show t => [t] -> IO ()
imprime l = do
    putStrLn (formataLista l)
    return ()

imprimeEmUmaLinha :: [String] -> IO ()
imprimeEmUmaLinha l = do
    putStrLn (formataListaEmUmaLinha l)
    return ()

formataListaEmUmaLinha :: [String] -> String
formataListaEmUmaLinha [] = ""
formataListaEmUmaLinha (x:xs) = (x) ++ " " ++ (formataListaEmUmaLinha xs)

isValidDate :: String -> Bool
isValidDate date = 
    let dateList = split date '/' ""
        day = read (dateList !! 0) :: Int
        month = read (dateList !! 1) :: Int
        year = read (dateList !! 2) :: Int
    in day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 2024

isValidHour :: String -> Bool
isValidHour hour = 
    let horarios = ["08:00", "09:00", "10:00", "11:00", "13:00", "14:00", "15:00", "16:00", "17:00"]
    in elem hour horarios