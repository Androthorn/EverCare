module Haskell.Controllers.ClinicaController(
    criaClinica,
    criaMedico,
    validaClinica
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
criaMedico idC idM informs = read (intercalate ";" ([show (idC), show (idM)] ++ informs)) :: Medico.Medico
{-Essa função verifica se o Id da clínica está correto.
@param idC: id da clínica
@param clinica: lista de clínica
@return True se existir, False se não
-}
validaClinica :: Int -> [Clinica.Clinica] -> Bool
validaClinica _ [] = False
validaClinica idC (c:cs)
    | idC == Clinica.id c = True
    | otherwise = validaClinica idC cs






    
