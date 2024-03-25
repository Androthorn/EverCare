module Haskell.Controllers.MedicoController (
    getMedicoId,
    emiteReceita,
    emiteLaudo,
    solicitaExame,

) where

import qualified Haskell.Models.BD as BD
import Haskell.Models.Paciente
import qualified Haskell.Models.Medico as Medico
import Haskell.Models.Laudo as Laudo
import Haskell.App.Util
import Data.List (intercalate)
import qualified Haskell.Models.Receita as Receita
import System.IO


getMedicoId :: Int -> [Medico.Medico] -> Medico.Medico
getMedicoId idMedico medicos = head (filter (\medico -> Medico.id medico == idMedico) medicos)

acessarConsultas :: Int -> [Consulta.consulta] -> [Consulta.consulta]
    filter (\medico -> Medico.id medico == idMedico) medicos
acessarConsultas idMedico consultas = filter (\consulta -> Consulta.idMedico consulta == idMedico) consultas

emiteReceita :: Int -> Int -> [String] -> [Receita.Receita]
emiteReceita idMedico idPaciente texto = read (intercalate ";" ([show (idMedico), show (idPaciente)] ++ texto)) :: Receita

emiteLaudo :: Int -> Int -> [String] -> [Laudo.Laudo]
emiteLaudo idMedico idPaciente texto = read (intercalate ";" ([show (idMedico), show (idPaciente)] ++ texto)) :: Laudo

soliciataExame :: Int -> Int -> [String] -> [Exame.Exame]
solicitaExame idMedico idPaciente texto = read (intercalate ";" ([show (idMedico), show (idPaciente)] ++ texto)) :: Exame
