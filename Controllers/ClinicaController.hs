module Controllers.ClinicaController (
    criaClinica,
    criaMedico
) where

import qualified Models.DataBase as BD
import Models.Clinica
import qualified Models.Medico as Medico
import App.Util
import Data.List (intercalate)

{-
Cria uma clinica.
@param idC: Inteiro que representa o id da clinica.
@param infos: Lista de strings que contém as informações da clinica.
@return clinica criada.
-}
criaClinica :: Int -> [String] -> Clinica
criaClinica idC infos = read (intercalate ";" ([show (idC)] ++ infos)) :: Clinica

{-
Cadastra um médico.
@param idC: Inteiro que representa o id da clinica.
@param idM: Inteiro que representa o id do médico.
@param infos: Lista de strings que contém as informações do médico.
@return médico cadastrado.
-}
criaMedico :: Int -> Int -> [String] -> Medico.Medico
criaMedico idC idM infos = read (intercalate ";" ([show (idM)] ++ [show (idC)] ++ infos)) :: Medico.Medico