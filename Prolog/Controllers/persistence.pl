:- module(persistence, [savePaciente/0, saveIdPaciente/0, saveIdPaciente/0]).

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