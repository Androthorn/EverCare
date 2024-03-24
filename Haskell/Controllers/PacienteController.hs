{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
module Haskell.Controllers.PacienteController (
    criaPaciente,
    filtrarMedicosPorEspecialidade,
    filtrarPorClinica,
    filtrarClinicasPorPlanoDeSaude,
    filtrarClinicasPorAgendamento,
    filtrarOpcoes,
    consultarLaudo,
    consultarReceita
    
) where

import qualified Haskell.Models.BD as BD
import Haskell.Models.Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate)
import qualified Haskell.Models.Receita as Receita


{-
Cria um paciente.
@param idP: Inteiro que representa o id do paciente.
@param infos: Lista de strings que contém as informações do paciente.
@return paciente criado.
-}
criaPaciente :: Int -> [String] -> Paciente
criaPaciente idP infos = read (intercalate ";" ([show (idP)] ++ infos)) :: Paciente

{-
Essa função filtra uma lista de médicos com base na especialidade desejada.
@param especialidadeDesejada: A especialidade que se deseja encontrar nos médicos.
@param medicos: Uma lista de médicos que será filtrada.
@return Uma lista de médicos que possuem a especialidade desejada.
-}

filtrarMedicosPorEspecialidade :: String -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicosPorEspecialidade especialidadeDesejada medicos  =
    filter (\medico -> Medico.especialidade medico == especialidadeDesejada) medicos

{-Essa função filtra a clinica especifica desejeda.
@param nomeEspecifico: a clinica desejada
@param clinicas: a lista das clinias qu serão filtradas
@return a clinica desjada
-}

filtrarPorClinica :: String -> [Clinica.Clinica] -> [Clinica.Clinica]
filtrarPorClinica nomeEspecifico clinicas = 
    filter (\clinica -> Clinica.nome clinica == nomeEspecifico) clinicas
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
    filter (\clinica -> Clinica.tipoAgendamento clinica == tipoAgendamentoDesejado) clinicas


{-Essa função filtra uma lista de médicos ou clínicas com base em uma lista de filtros.
   Cada filtro é um par contendo o tipo de filtro e o valor desejado.
   Os tipos de filtro podem ser "especialidade", "clinica", "plano" ou "agendamento".
   @param filtros: Uma lista de pares contendo o tipo de filtro e o valor desejado.
   @param opcoes: Uma lista de médicos ou clínicas que será filtrada.
   @return Uma lista de médicos ou clínicas que atendem aos critérios de todos os filtros aplicados.
-}
filtrarOpcoes :: [(String, String)] -> [a] -> [a]
filtrarOpcoes filtros opcoes = foldl (\opts (filtro, valor) -> case filtro of
        "especialidade" -> filtrarMedicosPorEspecialidade valor opts
        "clinica" -> filtrarPorClinica valor opts
        "plano" -> filtrarClinicasPorPlanoDeSaude valor opts
        "agendamento" -> filtrarClinicasPorAgendamento valor opts
        _ -> opts) opcoes filtros

{-
Essa função filtra uma lista de laudos com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do paciente desejado.
-}
consultarLaudo :: Int -> [Laudo] -> [Laudo]
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

