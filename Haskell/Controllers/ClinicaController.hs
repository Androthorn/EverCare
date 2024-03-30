{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use Down" #-}
module Haskell.Controllers.ClinicaController(
    criaClinica,
    criaMedico,
    verMedico,
    dashboardC,
    showLista,
    getClinicaId,
    verPaciente,
    verConsultas,
    criarFilaVirtual,
    verFilasClinica
) where

import Data.List (intercalate, find, nub, sortBy)
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Paciente as Paciente
import Haskell.Models.Consulta (Consulta)
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Controllers.PacienteController as PControl
import qualified Haskell.Controllers.MedicoController as MControl
import qualified Haskell.Models.Fila as Fila

import Haskell.App.Util (leituraDadosClinica)
import Data.Ord (comparing)

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

dashboardC :: Int -> [Medico.Medico] -> [Consulta.Consulta] -> [Clinica.Clinica] -> String
dashboardC idC medicos consultas clinicas =
    --Poderia ter o nome da clinica (virginia)
    let medicoContagem = length (filter (\medico -> Medico.clinica medico == idC) medicos)
        consultasA = filter (\consulta -> Consulta.idClinica consulta == idC) consultas
        consultasContagem = length consultasA
        pacientesContagem = length (nub $ map Consulta.idPaciente consultasA)
    in
    "----------------------------\n" ++
    "DASHBOARD DA CLÍNICA: " ++ (getClinicaName idC clinicas) ++ "\n\n" ++
    "Quantidade de Médicos: " ++ show medicoContagem ++
    "\nQuantidade de Consultas: " ++ show consultasContagem ++
    "\nQuantidade de Pacientes: " ++ show pacientesContagem ++
    "\n---------------------------\n\n" ++
    "----------------------------\n" ++
    "Ranking de Médicos: \n" ++
    concatMap Medico.toStringAval (rankingMedicosPorNota idC clinicas medicos) ++
    "----------------------------\n"



rankingMedicosPorNota :: Int -> [Clinica.Clinica] -> [Medico.Medico] -> [Medico.Medico]
rankingMedicosPorNota idClinica clinicas medicos =
    let medicosDaClinica = filter (\medico -> Medico.clinica medico == idClinica) medicos
        medicosOrdenados = sortBy (flip $ comparing Medico.nota) medicosDaClinica
    in medicosOrdenados

criarFilaVirtual :: Int -> Int -> Int -> Fila.Fila
criarFilaVirtual id idC idM = Fila.Fila id idC idM []

verFilasClinica :: Int -> [Fila.Fila] -> String
verFilasClinica _ [] = ""
verFilasClinica idC filas =
    let filasList = filter (\fila -> Fila.idClinica fila == idC) filas
    in if null filasList then
        "Não há filas abertas nessa clínica"
    else
        showLista filasList
        

showLista :: Show a => [a] -> String
showLista = concatMap (\x -> show x ++ "\n")

getClinicaName :: Int -> [Clinica.Clinica] -> String
getClinicaName idC clinicas = 
    case find (\clinica -> Clinica.id clinica == idC) clinicas of
        Just clinica -> Clinica.nome clinica
        Nothing -> error "clinica not found"

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