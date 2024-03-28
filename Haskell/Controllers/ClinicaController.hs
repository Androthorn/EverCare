{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
module Haskell.Controllers.ClinicaController(
    criaClinica,
    criaMedico,
    verMedico,
    dashboardC,
    showLista,
    getClinicaId,
    verPaciente,
    verConsultas,
    validaClinica,
    validaIDExame,
    validaIDReceita,
    validaIDLaudo
) where

import Data.List (intercalate, find, nub)
import qualified Haskell.Models.Clinica as Clinica
import qualified Haskell.Models.Medico as Medico
import qualified Haskell.Models.Paciente as Paciente
import Haskell.Models.Consulta (Consulta)
import qualified Haskell.Models.Consulta as Consulta
import qualified Haskell.Models.Receita as Receita
import qualified Haskell.Models.Receita as Laudo
import qualified Haskell.Models.Exame as Exame
import qualified Haskell.Controllers.PacienteController as PControl
import Haskell.App.Util (leituraDadosClinica)

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

{- 
Esta função retorna a lista de médicos associados a uma clínica.
@param idC: ID da clínica
@param medicos: lista de médicos cadastrados
@return uma string representando a lista de médicos associados à clínica
-}
verMedico :: Int -> [Medico.Medico] -> String
verMedico _ [] = ""
verMedico idC medicos =
    let medicosList = filter (\medico -> Medico.clinica medico == idC) medicos
    in if null medicosList then
        "Não há médicos cadastrados nessa clínica"
    else
        showLista medicosList

{- 
Esta função retorna a lista de pacientes associados a uma clínica.
@param idC: ID da clínica
@param consultas: lista de consultas
@param pacientes: lista de pacientes cadastrados
@return uma string representando a lista de pacientes associados à clínica
-}
verPaciente :: Int -> [Consulta.Consulta] -> [Paciente.Paciente] -> String
verPaciente _ [] [] = ""
verPaciente _ [] _ = ""
verPaciente _ _ [] = ""
verPaciente idC consultas pacientes =
    let consultasFiltradas = filter (\consulta -> Consulta.idClinica consulta == idC) consultas
        pacientesF = nub $ map Consulta.idPaciente consultasFiltradas
        pacientesOK = map (\idP -> PControl.getPacienteOID idP pacientes) pacientesF
        infoPacientes = showLista pacientesOK
    in if null pacientesF then
        "Não há pacientes nessa clínica"
    else
        infoPacientes

{- 
Esta função retorna a lista de consultas associadas a uma clínica.
@param idC: ID da clínica
@param consultas: lista de consultas
@return uma string representando a lista de consultas associadas à clínica
-}
verConsultas :: Int -> [Consulta.Consulta] -> String
verConsultas _ [] = ""
verConsultas idC consultas =
    let consultasList = filter (\consulta -> Consulta.idClinica consulta == idC) consultas
    in if null consultasList then
        "Não há consultas cadastradas nessa clínica"
    else
        showLista consultasList

{-
Esta função retorna o dashboard da clinica.
@param idC: id da clinica
@param medicos: lista de medicos cadastrados
@return o dashboard da clinica
-}

dashboardC :: Int -> [Medico.Medico] -> [Consulta.Consulta] -> String
dashboardC idC medicos consultas =
    --Poderia ter o nome da clinica (virginia)
    let medicoContagem = length (filter (\medico -> Medico.clinica medico == idC) medicos)
        consultasContagem = length (filter (\consulta -> Consulta.idClinica consulta == idC) consultas)
        pacientesContagem = length (nub $ map Consulta.idPaciente consultas)
    in
    "----------------------------\n" ++
    "DASHBOARD DA CLÍNICA\n" ++
    "Quantidade de Médicos: " ++ show medicoContagem ++
    "\nQuantidade de Consultas: " ++ show consultasContagem ++
    "\nQuantidade de Pacientes: " ++ show pacientesContagem ++
    "\n---------------------------\n"
    


showLista :: Show a => [a] -> String
showLista = concatMap (\x -> show x ++ "\n")

{-
Esta função retorna o ID da clinica dado o seu nome.
@param name: nome da clinica
@param clinicas: lista de clinicas cadastradas
@return o ID da clinica
-}
getClinicaId :: String -> [Clinica.Clinica] -> Int
getClinicaId name clinicas = 
    case find (\clinica -> Clinica.nome clinica == name) clinicas of
        Just clinica -> Clinica.id clinica
        Nothing -> error "clinica not found"

{-
Esta função verifica se o Id da clínica está correto.
@param idC: id da clínica
@param clinica: lista de clínica
@return True se existir, False se não
-}
validaClinica :: Int -> [Clinica.Clinica] -> Bool
validaClinica _ [] = False
validaClinica idC (c:cs)
    | idC == Clinica.id c = True
    | otherwise = validaClinica idC cs

{-
Esta função verifica se existe exame com o id dado
@param idExame: id do exame
@param exames: lista dos exames
@return True se existir, False se não
-}
validaIDExame :: Int -> [Exame.Exame] -> Bool
validaIDExame _ [] = False
validaIDExame idExame (x:xs) | idExame == (Exame.id x) = True
                             | otherwise = validaIDExame idExame xs

{-
Esta função verifica se existe receita com o id dado
@param idReceita: id do receita
@param receitas: lista dos Receitas
@return True se existir, False se não
-}
validaIDReceita :: Int -> [Receita.Receita] -> Bool
validaIDReceita _ [] = False
validaIDReceita idReceita (x:xs) | idReceita == (Receita.id x) = True
                                 | otherwise = validaIDReceita idReceita xs
{-
Esta função verifica se existe laudo com o Id dado
@param idLaudo: id do laudo
@param laudos: lista de laudos
@return True se existir, False se não
-}
validaIDLaudo :: Int -> [Laudo.Laudo] -> Bool
validaIDLaudo _ [] = False
validaIDLaudo idLaudo (x:xs) | idLaudo == (Laudo.id x) = True
                             | otherwise = validaIDLaudo idLaudo xs
