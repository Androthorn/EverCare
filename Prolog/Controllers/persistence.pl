:- module(persistence, [savePaciente/0, saveClinica/0, saveMedico/0, saveConsulta/0]).

:- use_module('../Models/model.pl').

savePaciente :- tell('bd/paciente.pl'),
                listing(model:paciente),
                told.

saveClinica :- tell('bd/clinica.pl'),
                listing(model:clinica),
                told.

saveMedico :- tell('bd/medico.pl'),
                listing(model:medico),
                told.


saveConsulta :- tell('bd/consulta.pl'),
                listing(model:consulta),
                told.
                