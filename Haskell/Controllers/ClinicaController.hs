{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
module Haskell.Controllers.ClinicaController(
    criaClinica,
    criaMedico,
    verMedico,
    dashboardC,
    showLista,
    getClinicaId,
    verPaciente,
    verConsultas
) where

import Data.List (intercalate, find, nub)
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Paciente as Paciente
import Haskell.Models.Consulta (Consulta)
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Controllers.PacienteController as PControl

{-
Cria um clinica.
@param idC : Id da clinica
@param infos : informações da clinica
@return clinica criada
-}
criaClinica :: Int -> [String] -> Clinica.Clinica
criaClinica idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Clinica.Clinica

{-
Cria um médico
@param idC: id da clinica a qual o médico pertence
@param idM: id do médico
@param informs: informações do médico
@return médico cadastrado
-}
criaMedico :: Int -> Int -> [String] -> Medico.Medico
criaMedico idC idM informs = read (intercalate ";" ([show (idC)] ++ [show (idM)] ++ informs)) :: Medico.Medico

verMedico :: Int -> [Medico.Medico] -> String
verMedico _ [] = ""
verMedico idC medicos =
    let medicosList = filter (\medico -> Medico.clinica medico == idC) medicos
    in if null medicosList then
        "Não há médicos cadastrados nessa clínica"
    else
        showLista medicosList

verPaciente :: Int -> [Consulta.Consulta] -> [Paciente.Paciente] -> String
verPaciente _ [] [] = ""
verPaciente _ [] _ = ""
verPaciente _ _ [] = ""
verPaciente idC consultas pacientes =
    let consultasFiltradas = filter (\consulta -> Consulta.idClinica consulta == idC) consultas
        pacientesF = nub $ map Consulta.idPaciente consultasFiltradas
        pacientesOK = map (\idP -> PControl.getPacienteOID idP pacientes) pacientesF
        infoPacientes = showLista pacientesOK
    in if null pacientesF then
        "Não há pacientes nessa clínica"
    else
        infoPacientes

verConsultas :: Int -> [Consulta.Consulta] -> String
verConsultas _ [] = ""
verConsultas idC consultas =
    let consultasList = filter (\consulta -> Consulta.idClinica consulta == idC) consultas
    in if null consultasList then
        "Não há consultas cadastradas nessa clínica"
    else
        showLista consultasList

{-
Essa função retorna o dashboard da clinica.
@param idC: id da clinica
@param medicos: lista de medicos cadastrados
@return o dashboard da clinica
-}

dashboardC :: Int -> [Medico.Medico] -> [Consulta.Consulta] -> String
dashboardC idC medicos consultas =
    --Poderia ter o nome da clinica (virginia)
    let medicoContagem = length (filter (\medico -> Medico.clinica medico == idC) medicos)
        consultasContagem = length (filter (\consulta -> Consulta.idClinica consulta == idC) consultas)
        pacientesContagem = length (nub $ map Consulta.idPaciente consultas)
    in
    "----------------------------\n" ++
    "DASHBOARD DA CLÍNICA\n" ++
    "Quantidade de Médicos: " ++ show medicoContagem ++
    "\nQuantidade de Consultas: " ++ show consultasContagem ++
    "\nQuantidade de Pacientes: " ++ show pacientesContagem ++
    "\n---------------------------\n"
    


showLista :: Show a => [a] -> String
showLista = concatMap (\x -> show x ++ "\n")

{-
Essa função retorna o ID da clinica dado o seu nome.
@param name: nome da clinica
@param clinicas: lista de clinicas cadastradas
@return o ID da clinica
-}
getClinicaId :: String -> [Clinica.Clinica] -> Int
getClinicaId name clinicas = 
    case find (\clinica -> Clinica.nome clinica == name) clinicas of
        Just clinica -> Clinica.id clinica
        Nothing -> error "clinica not found"