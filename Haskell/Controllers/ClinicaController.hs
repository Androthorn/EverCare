module Haskell.Controllers.ClinicaController(
    criaClinica,
    criaMedico,
    verMedico,
    dashboardC
) where

import Data.List ( intercalate )
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico

{-
Cria um clinica.
@param idC : Id da clinica
@param infos : informações da clinica
@return clinica criada
-}
criaClinica :: Int -> [String] -> Clinica.Clinica
criaClinica idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Clinica.Clinica

{-
Cria um médico
@param idC: id da clinica a qual o médico pertence
@param idM: id do médico
@param informs: informações do médico
@return médico cadastrado
-}
criaMedico :: Int -> Int -> [String] -> Medico.Medico
criaMedico idC idM informs = read (intercalate ";" ([show (idC)] ++ [show (idM)] ++ informs)) :: Medico.Medico

verMedico :: Int -> [Medico.Medico] -> String
verMedico _ [] = ""
verMedico idC medicos =
    let medicosList = filter (\medico -> Medico.clinica medico == idC) medicos
    in if null medicosList then
        "Não há médicos cadastrados nessa clínica"
    else
        showLista medicosList

dashboardC :: Int -> [Medico.Medico] -> String
dashboardC idC medicos =
    --Poderia ter o nome da clinica (virginia)
    let medicoContagem = length (filter (\medico -> Medico.clinica medico == idC) medicos)
    in
    "----------------------------\n" ++
    "MÉDICOS DA CLÍNICA\n" ++
    "Quantidade de médicos: " ++ show medicoContagem ++ 
    "\n---------------------------\n"

showLista :: Show a => [a] -> String
showLista = concatMap (\x -> show x ++ "\n")



