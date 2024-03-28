module Haskell.Controllers.MedicoController (
    getMedicoId,
    getIdMedico,
    acessarConsultas,
    emiteReceita,
    emiteLaudo,
    solicitaExame,
    adicionaMedia,
    atualizaMedias
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

atualizaMedias :: [Avaliacao.Avaliacao] -> [Medico.Medico] -> [Medico.Medico]
atualizaMedias avaliacoes medicos = map (\medico -> adicionaMedia (Medico.id medico) avaliacoes medicos) medicos


adicionaMedia :: Int -> [Avaliacao.Avaliacao] -> [Medico.Medico] -> Medico.Medico
adicionaMedia idMedico avaliacoes medicos = 
    let media = mediaNotas idMedico avaliacoes
        medico = find (\medicoM -> Medico.id medicoM == idMedico) medicos
    in case medico of
        Just medico -> medico {Medico.nota = media}
        Nothing -> error "médico not found"

mediaNotas :: Int -> [Avaliacao.Avaliacao] -> Float
mediaNotas _ [] = 0
mediaNotas idMedico avaliacoes = 
    let avaliacoesM = filter (\avaliacao -> Avaliacao.idMed avaliacao == idMedico) avaliacoes
        notas = map (\avaliacao -> Avaliacao.nota avaliacao) avaliacoesM
    in (fromIntegral (sum notas)) / (fromIntegral (length notas))
