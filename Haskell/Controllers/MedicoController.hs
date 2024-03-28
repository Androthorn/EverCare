module Haskell.Controllers.MedicoController (
    getMedicoId,
    getIdMedico,
    acessarConsultas,
    emiteReceita,
    emiteLaudo,
    solicitaExame,
    validaIDMedico
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
{- 
Esta função retorna o nome do médico dado o seu ID.
@param idMedico: ID do médico
@param medicos: lista de médicos cadastrados
@return o nome do médico, se encontrado; caso contrário, retorna uma mensagem de erro
-}
getIdMedico :: Int -> [Medico.Medico] -> String
getIdMedico idMedico medicos = 
    case find (\medico -> Medico.id medico == idMedico) medicos of
        Just medico -> Medico.nome medico
        Nothing -> error "médico not found"

{- 
Esta função retorna uma lista de consultas associadas a um médico.
@param idMedico: ID do médico
@param consultas: lista de consultas
@return lista de consultas associadas ao médico
-}
acessarConsultas :: Int -> [Consulta.Consulta] -> [Consulta.Consulta]
acessarConsultas _ [] = []
acessarConsultas idMedico consultas = filter (\consulta -> Consulta.idMedico consulta == idMedico) consultas

{- 
Esta função emite uma receita médica.
@param id: ID da receita
@param idMedico: ID do médico que emite a receita
@param infos: informações sobre a receita (como ID do paciente e texto)
@return a receita médica
-}
emiteReceita :: Int -> Int -> [String] -> Receita.Receita
emiteReceita id idMedico infos = Receita.Receita id idMedico idPaciente texto
    where
        idPaciente = read (head infos) :: Int
        texto = unwords (tail infos)

{- 
Esta função emite um laudo médico.
@param id: ID do laudo
@param idMedico: ID do médico que emite o laudo
@param idPaciente: ID do paciente relacionado ao laudo
@param texto: texto do laudo
@return o laudo médico
-}
emiteLaudo :: Int -> Int -> Int -> String -> Laudo.Laudo
emiteLaudo id idMedico idPaciente texto = read (intercalate ";" ([show (id), show (idMedico), show (idPaciente)] ++ [texto])) :: Laudo.Laudo

{- 
Esta função solicita um exame.
@param id: ID do exame
@param idMedico: ID do médico que solicita o exame
@param idPaciente: ID do paciente relacionado ao exame
@param tipo: tipo de exame
@param dia: dia em que o exame foi solicitado
@return o exame solicitado
-}
solicitaExame :: Int -> Int -> Int -> String -> String -> Exame.Exame
solicitaExame id idMedico idPaciente tipo dia = Exame.Exame id idPaciente idMedico tipo dia

{-
Esta função verifica se existe algum Medico com o id recebido.
@param idM: id do médico
@param medico: lista dos medicos
@return True se existir, False se não
-}
validaIDMedico :: Int -> [Medico.Medico] -> Bool
validaIDMedico _ [] = False
validaIDMedico idM (x:xs) | idM == (Medico.id x) = True
                            | otherwise = validaIDMedico idM xs


