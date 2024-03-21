module Haskell.Persistence.Persistence where

import qualified Haskell.Models.DataBase as BD
import Haskell.App.Util (split)
import System.IO

carregaTodos :: IO BD.BD
carregaTodos = do
    novoBanco <- carregaPacientes BD.novoBD
    novoBanco2 <- carregaLoginsPaciente novoBanco
    return novoBanco2

carregaPacientes :: BD.BD -> IO BD.BD
carregaPacientes dados = do
    conteudo <- leConteudo "pacientes.txt"
    return (dados {BD.pacientes = BD.stringToPacientes $ split conteudo '\n' ""})

carregaLoginsPaciente :: BD.BD -> IO BD.BD
carregaLoginsPaciente dados = do
    conteudo <- leConteudo "loginspacientes.txt"
    return (dados {BD.loginsPacientes = BD.stringToLoginsPaciente $ split conteudo '\n' "",
                   BD.idAtualPaciente = length (BD.stringToLoginsPaciente $ split conteudo '\n' "") + 1})


-- Função para salvar os pacientes no arquivo
-- encerrar :: BD.BD -> IO ()
-- encerrar dados = do
--     let path = "Persistence/"
--     let pacientes = BD.pacientes dados
--     let loginsPacientes = BD.loginsPacientes dados

--     withFile "Persistence/loginspacientes.txt" ReadWriteMode $ \handle -> do
--         let loginsStr = BD.loginsPacientesToString loginsPacientes ""
--         hPutStr handle loginsStr  -- Escreve no arquivo

--     withFile "Persistence/pacientes.txt" ReadWriteMode $ \handle -> do
--         let pacientesStr = BD.pacientesToString pacientes ""
--         hPutStr handle pacientesStr  -- Escreve no arquivo

encerrar :: BD.BD -> IO ()
encerrar dados = do
    let path = "Persistence/"
    let pacientes = BD.pacientes dados
    let loginsPacientes = BD.loginsPacientes dados

    -- Escreve loginsPacientes no arquivo
    writeFile "Persistence/loginspacientes.txt" (BD.loginsPacientesToString loginsPacientes "")

    -- Escreve pacientes no arquivo
    writeFile "Persistence/pacientes.txt" (BD.pacientesToString pacientes "")


leConteudo :: String -> IO String
leConteudo arquivo = readFile ("Persistence/" ++ arquivo)

escreveConteudo :: String -> String -> IO ()
escreveConteudo arquivo conteudo = writeFile ("Persistence/" ++ arquivo) conteudo

