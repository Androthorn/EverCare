:- module(persistence, [savePaciente/0, saveIdPaciente/0, saveIdPaciente/0, saveClinica/0, saveIdClinica/0,
                        saveLoginClinica/0, saveMedico/0, saveIdMedico/0, saveLoginMedico/0, 
                        saveConsulta/0, saveIdConsulta/0,
                        saveChat/0, saveIdChat/0]).

:- use_module('../Models/model.pl').


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

saveConsulta :- tell('bd/consulta/consulta.bd'),
                listing(model:consulta),
                told.

saveIdConsulta :- tell('bd/consulta/id_consulta.bd'),
                  listing(model:id_consulta),
                  told.
saveReceita :-
    tell('bd/pos_consulta/receita.bd'), 
    listing(model:receita), 
    told. 
saveLaudo :-
    tell('bd/pos_consulta/laudo.bd'),
    listing(model:laudo), 
    told. 
saveExame :-
    tell('bd/pos_consulta/exame.bd'), 
    listing(model:exame), 
    told. 

saveChat :-
    tell('bd/chat/chat.bd'), 
    listing(model:chat), 
    told.
saveIdChat :-
    tell('bd/chat/id_chat.bd'), 
    listing(model:id_chat), 
    told.
