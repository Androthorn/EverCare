{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}

module Haskell.Controllers.PacienteController (
    criaPaciente,
    criaConsulta,
    filtrarMedicosPorEspecialidade,
    consultarLaudo,
    consultarReceita,
    getPacienteId,
    getPacienteName
) where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Paciente as Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate, find)
import qualified Haskell.Models.Receita as Receita
import Haskell.Models.Consulta (Consulta(Consulta))


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
criaConsulta :: Int -> [String] -> Consulta
criaConsulta idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Consulta

{-
Essa função filtra uma lista de médicos com base na especialidade desejada.
@param especialidadeDesejada: A especialidade que se deseja encontrar nos médicos.
@param medicos: Uma lista de médicos que será filtrada.
@return Uma lista de médicos que possuem a especialidade desejada.
-}

filtrarMedicosPorEspecialidade :: String -> [Medico.Medico] -> [Medico.Medico]
filtrarMedicosPorEspecialidade especialidadeDesejada medicos  =
    filter (\medico -> Medico.especialidade medico == especialidadeDesejada) medicos

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