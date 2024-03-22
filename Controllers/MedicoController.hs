module Controllers.MedicoController (
    criaPaciente
) where

import qualified Models.DataBase as BD
import Models.Medico
import App.Util
import Data.List (intercalate)

{-
Cria um médico.
@param crm: String que representa o CRM do médico.
@param nome: String que representa o nome do médico.
@param id: Inteiro que representa o id do médico.
@param especialidade: String que representa a especialidade do médico.
@param clinica: String que representa a clínica do médico.
@return médico criado.
-}
criaMedico :: String -> String -> Int -> String -> String -> Medico
criaMedico crm nome id especialidade clinica = Medico crm nome id especialidade clinica

{-
Essa função filtra uma lista de laudos com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do paciente desejado.
-}
consultarLaudo :: Int -> [Laudo] -> [Laudo]
consultarLaudo _ [] = []
consultarLaudo idPaciente laudos = filter (\laudo -> Medico.id laudo == idPaciente) laudos

{-
Essa função filtra uma lista de receitas com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nas receitas.
@param receitas: Uma lista de receitas que será filtrada.
@return Uma lista de receitas que possuem o id do paciente desejado.
-}
consultarReceita :: Int -> [Receita] -> [Receita]
consultarReceita _ [] = []
consultarReceita idPaciente receitas = filter (\receita -> Receita.idPaciente receita == idPaciente) receitas

{-
Essa função filtra uma lista de médicos com base na especialidade desejada.
@param especialidadeDesejada: A especialidade que se deseja encontrar nos médicos.
@param medicos: Uma lista de médicos que será filtrada.
@return Uma lista de médicos que possuem a especialidade desejada.
-}
filtrarMedicosPorEspecialidade :: String -> [Medico] -> [Medico]
filtrarMedicosPorEspecialidade especialidadeDesejada medicos  =
    filter (\medico -> especialidade medico == especialidadeDesejada) medicos