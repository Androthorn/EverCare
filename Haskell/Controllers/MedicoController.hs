module Controllers.MedicoController where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate)
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Receita as Laudo


{-
Essa função filtra uma lista de laudos com base no id do médico.
@param idMedico: O id do paciente que se deseja encontrar nos laudos.
@param laudos: Uma lista de laudos que será filtrada.
@return Uma lista de laudos que possuem o id do médico desejado.
-}
consultarLaudo :: Int -> [Laudo.Laudo] -> [Laudo.Laudo]
consultarLaudo _ [] = []
consultarLaudo idMedico laudos = filter (\laudo -> Laudo.idMed laudo == idMedico) laudos

-- Isso não deveria ser uma função de Paciente? Não entendi (Virginia)
{-
Essa função filtra uma lista de receitas com base no id do paciente.
@param idPaciente: O id do paciente que se deseja encontrar nas receitas.
@param receitas: Uma lista de receitas que será filtrada.
@return Uma lista de receitas que possuem o id do paciente desejado.
-}
consultarReceita :: Int -> [Receita.Receita] -> [Receita.Receita]
consultarReceita _ [] = []
consultarReceita idPaciente receitas = filter (\receita -> Receita.idPaciente receita == idPaciente) receitas