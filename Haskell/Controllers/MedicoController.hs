module Haskell.Controllers.MedicoController (
    getMedicoId,
    getIdMedico,
    acessarConsultas,
    emiteReceita,
    emiteLaudo,
    solicitaExame,
    -- atualizarMediaNotasMedico,
    -- atualizaNumAvaliacoesMedico,
    -- atualizaMedias,
    getMedico,
    adicionaMedia
)where

import qualified Haskell.Models.BD as BD
import qualified Haskell.Models.Medico as Medico
import Haskell.App.Util
import Data.List (intercalate, find)
import Data.Char (toLower)
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
getMedicoId :: String -> [Medico.Medico] -> Maybe Int
getMedicoId name medicos = 
    case find (\medico -> (map toLower $ Medico.nome medico) == (map toLower name)) medicos of
        Just medico -> Just (Medico.id medico)
        Nothing -> Nothing

getMedico :: Int -> [Medico.Medico] -> Medico.Medico
getMedico idMedico medicos = 
    case find (\medico -> Medico.id medico == idMedico) medicos of
        Just medico -> medico
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

-- atualizarMediaNotasMedico :: Int -> Float -> [Medico.Medico] -> [Medico.Medico]
-- atualizarMediaNotasMedico _ _ [] = []
-- atualizarMediaNotasMedico idMed novaNota (medico:medicos)
--     | idMed == Medico.id medico = novoMedico : atualizarMediaNotasMedico idMed novaNota medicos
--     | otherwise = medico : atualizarMediaNotasMedico idMed novaNota medicos
--     where
--         numAvaliacoes = fromIntegral (Medico.numAvaliacoes medico)
--         notaAntiga = Medico.nota medico
--         novaMedia = ((notaAntiga * numAvaliacoes) + novaNota) / (numAvaliacoes + 1)
--         novoMedico = medico { Medico.nota = novaMedia }

-- atualizaMedias :: BD.BD -> IO [Medico.Medico]
-- atualizaMedias dados = do
--     let medicos = BD.medicos dados
--         avaliacoes = BD.avaliacoes dados
--         medicosAtualizados = map (\medico -> adicionaMedia (Medico.id medico) avaliacoes medicos) medicos
--         bdAtualizado = dados { BD.medicos = medicosAtualizados }
--     BD.limpaArquivo "Haskell/Persistence/medicos.txt"
--     BD.escreveNoArquivoSemContra "Haskell/Persistence/medicos.txt" (BD.medicosToString (BD.medicos bdAtualizado) "")
--     return medicosAtualizados 

adicionaMedia :: Int -> [Avaliacao.Avaliacao] -> [Medico.Medico] -> [Medico.Medico]
adicionaMedia idMedico avaliacoes medicos = 
    let media = mediaNotas idMedico avaliacoes
        atualizarMedico m = if Medico.id m == idMedico
                            then m { Medico.nota = media }
                            else m
    in map atualizarMedico medicos

mediaNotas :: Int -> [Avaliacao.Avaliacao] -> Float
mediaNotas _ [] = 0
mediaNotas idMedico avaliacoes = 
    let avaliacoesM = filter (\avaliacao -> Avaliacao.idMed avaliacao == idMedico) avaliacoes
        notas = map (\avaliacao -> Avaliacao.nota avaliacao) avaliacoesM
    in (fromIntegral (sum notas)) / (fromIntegral (length notas))
