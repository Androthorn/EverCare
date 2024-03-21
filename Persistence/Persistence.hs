module Persistence.Persistence where

import qualified Models.DataBase as BD
import App.Util (split)
import System.IO
import System.Directory

carregaTodos :: IO BD.BD
carregaTodos = do
    novoBanco <- carregaPacientes BD.novoBD
    novoBanco2 <- carregaLoginsPaciente novoBanco
    novoBanco3 <- carregaClinicas novoBanco2
    novoBanco4 <- carregaLoginsClinica novoBanco3
    return novoBanco4



carregaPacientes :: BD.BD -> IO BD.BD
carregaPacientes dados = do
    conteudo <- leConteudo "pacientes.txt"
    return (dados {BD.pacientes = BD.stringToPacientes $ split conteudo '\n' ""})

carregaLoginsPaciente :: BD.BD -> IO BD.BD
carregaLoginsPaciente dados = do
    conteudo <- leConteudo "loginspacientes.txt"
    return (dados {BD.loginsPacientes = BD.stringToLoginsPaciente $ split conteudo '\n' "",
                   BD.idAtualPaciente = length (BD.stringToLoginsPaciente $ split conteudo '\n' "") + 1})

carregaClinicas :: BD.BD -> IO BD.BD
carregaClinicas dados = do
    conteudo <- leConteudo "clinicas.txt"
    return (dados {BD.clinicas = BD.stringToClinicas $ split conteudo '\n' ""})

carregaLoginsClinica :: BD.BD -> IO BD.BD 
carregaLoginsClinica dados = do
    conteudo <- leConteudo "loginsclinicas.txt"
    return (dados {BD.loginsClinica = BD.stringToLoginsClinica $ split conteudo '\n' "",
                   BD.idAtualClinica = length (BD.stringToLoginsClinica $ split conteudo '\n' "") + 1})

salvaPacientes :: BD.BD -> IO ()
salvaPacientes dados = do
    let pacientes = BD.pacientes dados
    let pacientesStr = BD.pacientesToString pacientes ""
    escreveConteudo "loginspacientes.txt" pacientesStr

salvaLoginsPaciente :: BD.BD -> IO ()
salvaLoginsPaciente dados = do
    let loginsPacientes = BD.loginsPacientes dados
    let loginsStr = BD.loginsPacientesToString loginsPacientes ""
    escreveConteudo "loginspacientes.txt" loginsStr

salvaClinicas :: BD.BD -> IO ()
salvaClinicas dados = do
    let clinicas = BD.clinicas dados
    let clinicasStr = BD.clinicasToString clinicas ""
    escreveConteudo "clinicas.txt" clinicasStr

salvaLoginsClinica :: BD.BD -> IO ()
salvaLoginsClinica dados = do
    let loginsClinica = BD.loginsClinica dados
    let loginsStr = BD.loginsClinicaToString loginsClinica ""
    escreveConteudo "loginsclinicas.txt" loginsStr

salvaMedicos :: BD.BD -> IO ()
salvaMedicos dados = do
    let medicos = BD.medicos dados
    let medicosStr = BD.medicosToString medicos ""
    escreveConteudo "medicos.txt" medicosStr

salvaLoginsMedico :: BD.BD -> IO ()
salvaLoginsMedico dados = do
    let loginsMedico = BD.loginsMedico dados
    let loginsStr = BD.loginsMedicoToString loginsMedico ""
    escreveConteudo "loginsmedicos.txt" loginsStr

salvaTodos :: BD.BD -> IO ()
salvaTodos dados = do
    salvaLoginsClinica dados
    salvaLoginsPaciente dados
    salvaLoginsMedico dados
    salvaPacientes dados
    salvaClinicas dados
    salvaMedicos dados


-- Função para salvar os pacientes no arquivo
encerrar :: BD.BD -> IO ()
encerrar dados = do
    let path = "Persistence/"
    let pacientes = BD.pacientes dados
    let loginsPacientes = BD.loginsPacientes dados

    withFile "Persistence/loginspacientes.txt" ReadWriteMode $ \handle -> do
        let loginsStr = BD.loginsPacientesToString loginsPacientes ""
        hPutStr handle loginsStr  -- Escreve no arquivo

    withFile "Persistence/loginsclinicas.txt" ReadWriteMode $ \handle -> do
        let loginsClinica = BD.loginsClinica dados
        let loginsStr = BD.loginsClinicaToString loginsClinica ""
        hPutStr handle loginsStr  -- Escreve no arquivo

    withFile "Persistence/pacientes.txt" ReadWriteMode $ \handle -> do
        let pacientesStr = BD.pacientesToString pacientes ""
        hPutStr handle pacientesStr  -- Escreve no arquivo

    withFile "Persistence/clinicas.txt" ReadWriteMode $ \handle -> do
        let clinicas = BD.clinicas dados
        let clinicasStr = BD.clinicasToString clinicas ""
        hPutStr handle clinicasStr  -- Escreve no arquivo


leConteudo :: String -> IO String
leConteudo arquivo = readFile ("Persistence/" ++ arquivo)

escreveConteudo :: String -> String -> IO ()
escreveConteudo arquivo conteudo = writeFile ("Persistence/" ++ arquivo) conteudo

