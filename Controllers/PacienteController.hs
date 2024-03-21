module Controllers.PacienteController (
    criaPaciente
) where

import qualified Models.DataBase as BD
import Models.Paciente
import App.Util
import Data.List (intercalate)

{-
Cria um paciente.
@param idP: Inteiro que representa o id do paciente.
@param infos: Lista de strings que contém as informações do paciente.
@return paciente criado.
-}
criaPaciente :: Int -> [String] -> Paciente
criaPaciente idP infos = read (intercalate ";" ([show (idP)] ++ infos)) :: Paciente

criaPacienteJaID [String] -> Paciente
criaPacienteJaID infos = read (intercalate ";" infos) :: Paciente