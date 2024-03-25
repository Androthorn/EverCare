{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}

module Haskell.Controllers.PacienteController (
    criaPaciente,
    criaConsulta,
    filtrarMedicosPorEspecialidade,
    filtrarPorClinica,
    filtrarPorMedico,
    filtrarClinicasPorPlanoDeSaude,
    filtrarClinicasPorAgendamento,
    filtrarMedicoPorSintoma,
    consultarLaudo,
    consultarReceita,
    getPacienteId,
    getPacienteName
) where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Laudo as Laudo
import Haskell.App.Util

import Data.List (intercalate, find)


{-
Cria um paciente.
@param idP: Inteiro que representa o id do paciente.
@param infos: Lista de strings que contém as informações do paciente.
@return paciente criado.
-}
criaPaciente :: Int -> [String] -> Paciente.Paciente
criaPaciente idP infos = read (intercalate ";" ([show (idP)] ++ infos)) :: Paciente.Paciente

{-
Cria um paciente.
@param idC: Inteiro que representa o id da consulta.
@param infos: Lista de strings que contém as informações da consulta.
@return consulta criada.
-}
criaConsulta :: Int -> [String] -> Consulta.Consulta
criaConsulta idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Consulta.Consulta

{-Essa função filtra uma lista de médicos com base na especialidade desejada.
@param especialidadeDesejada: A especialidade que se deseja encontrar nos médicos.
@param medicos: Uma lista de médicos que será filtrada.
@return Uma lista de médicos que possuem a especialidade desejada.
-}
filtrarMedicosPorEspecialidade :: String -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicosPorEspecialidade especialidadeDesejada medicos  =
    filter (\medico -> Medico.especialidade medico == especialidadeDesejada) medicos

{-Essa função filtra a clinica especifica desejeda.
@param nomeEspecifico: a clinica desejada
@param clinicas: a lista das clinias que serão filtradas
@return a clinica desjada
-}
filtrarPorClinica :: String -> [Clinica.Clinica] -> [Clinica.Clinica]
filtrarPorClinica nomeEspecifico clinicas = 
    filter (\clinica -> Clinica.nome clinica == nomeEspecifico) clinicas


{-Essa função filtra um médico.
@param medicoEspecifico: o médico desejado.
@param medicos: a lista de médico que será filtrada
-}
filtrarPorMedico :: String ->[Medico.Medico] -> [Medico.Medico]
filtrarPorMedico medicoEspecifico medicos =
    filter(\medico -> Medico.nome medico == medicoEspecifico ) medicos


{-Essa função filtra uma lista de clínicas com base no plano de saúde desejado.
   @param planoSaudeDesejado: O plano de saúde desejado.
   @param clinicas: A lista de clínicas que será filtrada.
   @return A lista de clínicas que aceitam o plano de saúde desejado.
-}
filtrarClinicasPorPlanoDeSaude :: String -> [Clinica.Clinica] -> [Clinica.Clinica]
filtrarClinicasPorPlanoDeSaude planoSaudeDesejado clinicas =
    filter (\clinica -> elem planoSaudeDesejado (Clinica.planos clinica)) clinicas


{-Essa função filtra uma lista de clínicas com base no tipo de agendamento desejado.
   @param tipoAgendamentoDesejado: O tipo de agendamento desejado (por exemplo, "hora marcada" ou "ordem de chegada").
   @param clinicas: A lista de clínicas que será filtrada.
   @return A lista de clínicas que oferecem o tipo de agendamento desejado.
-}
filtrarClinicasPorAgendamento :: String -> [Clinica.Clinica] -> [Clinica.Clinica]
filtrarClinicasPorAgendamento tipoAgendamentoDesejado clinicas =
    filter (\clinica -> Clinica.metodoAgendamento clinica == tipoAgendamentoDesejado) clinicas


{-Esta função filtra uma lista de médicos de acordo com sintomas especificos
@return uma lista de médicos filtrada de acordo com o sintoma.
-}
filtrarMedicoPorSintoma :: String -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicoPorSintoma sintoma medicos
    | sintoma == "dor nas costas" || sintoma == "dor lombar" || sintoma == "dor na mão" || sintoma == "dor no pé" || sintoma == "dor na ombro" = filtrarMedicosPorEspecialidade "Ortopedista" medicos
    | sintoma == "enxaqueca" || sintoma == "dor de cabeça" = filtrarMedicosPorEspecialidade "Neurologia" medicos
    | sintoma == "dor de garganta" || sintoma == "nariz entupido" || sintoma == "sinusite" || sintoma == "dor de ouvido" = filtrarMedicosPorEspecialidade "Otorrinolaingologista" medicos
    | sintoma == "menstruação desrregulada" || sintoma == "gravidez" || sintoma == "cólica" = filtrarMedicosPorEspecialidade "Ginecologista" medicos
    | sintoma == "espinhas" || sintoma == "queda de cabelo" || sintoma == "mancha na pele" = filtrarMedicosPorEspecialidade "Dermatologista" medicos
    | sintoma == "desconforto abdominal" || sintoma == "azia" || sintoma == "gastrite" = filtrarMedicosPorEspecialidade "Gastroenterologia" medicos
    | sintoma == "febre" || sintoma == "tosse" || sintoma == "resfriado" || sintoma == "dor de garganta" = filtrarMedicosPorEspecialidade "Clínico Geral" medicos
    | sintoma == "pressão alta" || sintoma == "pressão baixa" = filtrarMedicosPorEspecialidade "Cardiologia" medicos
    | sintoma == "ansiedade" || sintoma == "depressão" = filtrarMedicosPorEspecialidade "Psiquiatria" medicos
    | sintoma == "visão embaçada" || sintoma == "olho vermelho" || sintoma == "coceira nos olhos" = filtrarMedicosPorEspecialidade "Oftalmologia" medicos
    | sintoma == "queda de pressão" || sintoma == "desmaio" = filtrarMedicosPorEspecialidade "Cardiologia" medicos
    | sintoma == "dor nos rins" || sintoma == "sangue na urina" || sintoma == "dificuldade para urinar" = filtrarMedicosPorEspecialidade "Urologia" medicos
    | otherwise = []

{-
Essa função filtra uma lista de laudos com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do paciente desejado.
-}
consultarLaudo :: Int -> [Laudo.Laudo] -> [Laudo.Laudo]
consultarLaudo _ [] = []
consultarLaudo idPaciente laudos = filter (\laudo -> Laudo.id laudo == idPaciente) laudos



{-
Essa função filtra uma lista de receitas com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nas receitas.
@param receitas: Uma lista de receitas que será filtrada.
@return Uma lista de receitas que possuem o id do paciente desejado.
-}
consultarReceita :: Int -> [Receita.Receita] -> [Receita.Receita]
consultarReceita _ [] = []
consultarReceita idPaciente receita = filter (\receita -> Receita.idPaciente receita == idPaciente) receita



{- 
Essa função retorna o ID do paciente dado o seu nome.
@param name: nome do paciente
@param pacientes: lista de pacientes cadastrados
@return o ID do paciente
-}
getPacienteId :: String -> [Paciente.Paciente] -> Int
getPacienteId name pacientes = 
    case find (\paciente -> Paciente.nome paciente == name) pacientes of
        Just paciente -> Paciente.id paciente
        Nothing -> error "paciente not found"

{-
Essa função retorna o nome do paciente dado o seu ID.
@param idPaciente: ID do paciente
@param pacientes: lista de pacientes cadastrados
@return o nome do paciente
-}
getPacienteName :: Int -> [Paciente.Paciente] -> String
getPacienteName idPaciente pacientes = 
    case find (\paciente -> Paciente.id paciente == idPaciente) pacientes of
        Just paciente -> Paciente.nome paciente
        Nothing -> error "paciente not found"