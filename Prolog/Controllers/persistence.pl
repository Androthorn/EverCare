:- module(persistence, [savePaciente/0, saveIdPaciente/0, saveIdPaciente/0, saveClinica/0, saveIdClinica/0,
                        saveLoginClinica/0, saveMedico/0, saveIdMedico/0, saveLoginMedico/0]).

:- use_module('../Models/model.pl').

/*
lePaciente/0, leUBS/0, leMedico/0, leMedico/0, leReceita/0, leMedicamento/0,
                        leLaudo/0, leExame/0, leLogins/0, leConsulta/0, leId/0, 

*/

savePaciente :- tell('bd/paciente/paciente.bd'),
                listing(model:paciente),
                told.

saveLoginPaciente :- tell('bd/paciente/login_paciente.bd'),
                     listing(model:login_paciente),
                     told.

saveIdPaciente :- tell('bd/paciente/id_paciente.bd'),
                  listing(model:id_paciente),
                  told.

saveClinica :- tell('bd/clinica/clinica.bd'),
               listing(model:clinica),
               told.

saveLoginClinica :- tell('bd/clinica/login_clinica.bd'),
                    listing(model:login_clinica),
                    told.

saveIdClinica :- tell('bd/clinica/id_clinica.bd'),
                    listing(model:id_clinica),
                    told.

saveIdMedico :- tell('bd/medico/id_medico.bd'),
                listing(model:id_medico),
                told.

saveMedico :- tell('bd/medico/medico.bd'),
                listing(model:medico),
                told. 

saveLoginMedico :- tell('bd/medico/login_medico.bd'),
                    listing(model:login_medico),
                    told.