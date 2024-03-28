module Haskell.Controllers.MedicoController (
    getMedicoId,
    getIdMedico,
    acessarConsultas,
    emiteReceita,
    emiteLaudo,
    solicitaExame,
    atualizarMediaNotasMedico,
    atualizaNumAvaliacoesMedico
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
import qualified Haskell.Models.Avaliacao as Avaliacao



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
        Nothing -> error "médico not found"

getIdMedico :: Int -> [Medico.Medico] -> String
getIdMedico idMedico medicos = 
    case find (\medico -> Medico.id medico == idMedico) medicos of
        Just medico -> Medico.nome medico
        Nothing -> error "médico not found"

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


atualizarMediaNotasMedico :: Int -> Int -> [Medico.Medico] -> [Medico.Medico]
atualizarMediaNotasMedico _ _ [] = []
atualizarMediaNotasMedico idMed novaNota (medico:medicos)
  | idMed == Medico.id medico = novoMedico : atualizarMediaNotasMedico idMed novaNota medicos
  | otherwise = medico : atualizarMediaNotasMedico idMed novaNota medicos
  where
    numAvaliacoes = fromIntegral (Medico.numAvaliacoes medico)
    notaAntiga = Medico.nota medico
    novaMedia = (notaAntiga * numAvaliacoes + novaNota) / (numAvaliacoes + 1)
    novoMedico = medico { Medico.nota = novaMedia }


atualizaNumAvaliacoesMedico :: Int -> [Medico.Medico] -> [Medico.Medico]
atualizaNumAvaliacoesMedico _ [] = []
atualizaNumAvaliacoesMedico idMed (medico:medicos)
  | idMed == Medico.id medico = novoMedico : atualizaNumAvaliacoesMedico idMed medicos
  | otherwise = medico : atualizaNumAvaliacoesMedico idMed medicos
  where
    novoMedico = medico { Medico.numAvaliacoes = Medico.numAvaliacoes medico + 1 }
