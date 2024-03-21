module Controllers.ClinicaController (
    criaClinica
) where

import qualified Models.DataBase as BD
import Models.Clinica
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

