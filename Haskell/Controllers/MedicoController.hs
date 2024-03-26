module Haskell.Controllers.MedicoController (
    getMedicoId,
    acessarConsultas,
    emiteReceita,
    emiteLaudo,
    solicitaExame
)where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Medico as Medico
import Haskell.App.Util
import Data.List (intercalate, find)
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Receita as Laudo
import qualified Haskell.Models.Exame as Exame
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Laudo as Laudo



{- 
Essa função retorna o ID do medico dado o seu nome.
@param name: nome do medico
@param medicos: lista de medicos cadastrados
@return o ID do medico
-}
getMedicoId :: String -> [Medico.Medico] -> Int
getMedicoId name medicos = 
    case find (\medico -> Medico.nome medico == name) medicos of
        Just medico -> Medico.id medico
        Nothing -> error "paciente not found"


acessarConsultas :: Int -> [Consulta.Consulta] -> [Consulta.Consulta]
acessarConsultas _ [] = []
acessarConsultas idMedico consultas = filter (\consulta -> Consulta.idMedico consulta == idMedico) consultas

emiteReceita :: Int -> Int -> [String] -> Receita.Receita
emiteReceita id idMedico infos = Receita.Receita id idMedico idPaciente texto
    where
        idPaciente = read (head infos) :: Int
        texto = unwords (tail infos)

emiteLaudo :: Int -> Int -> Int -> String -> Laudo.Laudo
emiteLaudo id idMedico idPaciente texto = read (intercalate ";" ([show (id), show (idMedico), show (idPaciente)] ++ [texto])) :: Laudo.Laudo

solicitaExame :: Int -> Int -> Int -> String -> String -> Exame.Exame
solicitaExame id idMedico idPaciente tipo dia = Exame.Exame id idPaciente idMedico tipo dia


