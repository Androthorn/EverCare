{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}

module Haskell.Controllers.PacienteController (
    criaPaciente,
    criaAvaliacao,
    criaConsulta,
    filtrarPorClinica,
    filtrarPorMedico,
    filtrarClinicasPorPlanoDeSaude,
    filtrarClinicasPorAgendamento,
    filtrarMedicosPorAvaliacoes,
    consultarLaudo,
    consultarReceita,
    consultarAgendamento,
    consultarSolicitacao,
    getPacienteId,
    getPacienteName,
    getPacienteOID
) where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Laudo as Laudo
import qualified Haskell.Models.Exame as Exame
import qualified Haskell.Models.Avaliacao as Avaliacao

import Haskell.App.Util
import Data.Char ( toLower )
import Data.List (intercalate, find)
import qualified Control.Applicative as ID

{-
Cria um paciente.
@param idP: Inteiro que representa o id do paciente.
@param infos: Lista de strings que contém as informações do paciente.
@return paciente criado.
-}
criaPaciente :: Int -> [String] -> Paciente.Paciente
criaPaciente idP infos = read (intercalate ";" ([show (idP)] ++ infos)) :: Paciente.Paciente

{-
Cria uma avaliação.
@param idA: Inteiro que representa o id da avaliação.
@param infos: Lista de strings que contém as informações da avaliação.
@return avaliação criada.
-}
criaAvaliacao :: Int -> [String] -> Avaliacao.Avaliacao
criaAvaliacao idA infos = read (intercalate ";" ([show (idA)] ++ infos)) :: Avaliacao.Avaliacao

{-
Cria um paciente.
@param idC: Inteiro que representa o id da consulta.
@param infos: Lista de strings que contém as informações da consulta.
@return consulta criada.
-}
criaConsulta :: Int -> [String] -> Consulta.Consulta
criaConsulta idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Consulta.Consulta

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

{-
Essa função filtra uma lista de médicos que tem notas acima de um certo valor.
@param valor: O valor mínimo da nota.
@param medicos: A lista de médicos que será filtrada.
@return A lista de médicos que possuem notas acima do valor mínimo.
-}

filtrarMedicosPorAvaliacoes :: Float -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicosPorAvaliacoes valor medicos = 
    filter (\medico -> Medico.nota medico >= valor) medicos

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

consultarSolicitacao :: Int -> [Exame.Exame] -> [Exame.Exame]
consultarSolicitacao _ [] = []
consultarSolicitacao idPaciente exames = filter (\exame -> Exame.idPaciente exame == idPaciente) exames


consultarAgendamento :: Int -> [Consulta.Consulta] -> [Consulta.Consulta]
consultarAgendamento _ [] = []
consultarAgendamento idPaciente consultas = filter (\consulta -> Consulta.idPaciente consulta == idPaciente) consultas

{- 
Essa função retorna o ID do paciente dado o seu nome.
@param name: nome do paciente
@param pacientes: lista de pacientes cadastrados
@return o ID do paciente
-}
getPacienteId :: String -> [Paciente.Paciente] -> Maybe Int
getPacienteId name pacientes = 
    case find (\paciente -> (map toLower $ Paciente.nome paciente) == (map toLower name)) pacientes of
        Just paciente -> Just (Paciente.id paciente)
        Nothing -> Nothing

{-
Essa função retorna o Paciente dado o seu ID.
@param idPaciente: ID do paciente
@param pacientes: lista de pacientes cadastrados
@return o paciente
-}
getPacienteOID :: Int -> [Paciente.Paciente] -> Paciente.Paciente
getPacienteOID idPaciente pacientes = 
    case find (\paciente -> Paciente.id paciente == idPaciente) pacientes of
        Just paciente -> paciente
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