{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
module Controllers.PacienteController (
    criaPaciente
) where

import qualified Models.DataBase as BD
import Models.Paciente
import qualified Models.Medico as Medico
import Models.Laudo as Laudo
import App.Util
import Data.List (intercalate)

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

{-
Essa função filtra uma lista de laudos com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do paciente desejado.
-}
consultarLaudo :: Int -> [Laudo] -> [Laudo]
consultarLaudo _ [] = []
consultarLaudo idPaciente laudos = filter (\laudo -> Laudo.id laudo == idPaciente) laudos

