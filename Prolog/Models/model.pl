:- module(model, [iniciaPaciente/0, iniciaIdPaciente/0, iniciaLoginPaciente/0, nextIdPaciente/1,
                  iniciaClinica/0, iniciaIdClinica/0, iniciaLoginClinica/0, nextIdClinica/1, 
                  iniciaMedico/0, iniciaIdMedico/0, iniciaLoginMedico/0, nextIdMedico/1, 
                  iniciaExame/0, iniciaIdExame/0, nextIdExame/1,
                  iniciaLaudo/0, iniciaIdLaudo/0, nextIdLaudo/1,
                  iniciaReceita/0, iniciaIdReceita/0, nextIdReceita/1
                ]).

:- use_module('../Controllers/persistence.pl').

/*
 Inicializa a tabela dinâmica de pacientes.
 Campos esperados: ID, Nome, CPF, Data de Nascimento, Sexo, Endereço, Plano de Saúde,
 Tipo Sanguíneo, Cardiopata (booleano), Diabético (booleano), Hipertenso (booleano), Senha.
*/
iniciaPaciente :-
    dynamic(paciente/12).

iniciaLoginPaciente :-
    dynamic(login_paciente/2).

iniciaIdPaciente :-
    asserta(id_paciente(0)).

nextIdPaciente(N) :-
    id_paciente(X), retract(id_paciente(X)), N is X + 1, asserta(id_paciente(N)).

lePaciente :- consult('bd/paciente/paciente.bd').
leLoginPaciente :- consult('bd/paciente/login_paciente.bd').
leIdPaciente :- consult('bd/paciente/id_paciente.bd').


verificaPaciente :- exists_file('bd/paciente/paciente.bd') -> lePaciente ; iniciaPaciente.
verificaLoginPaciente :- exists_file('bd/paciente/login_paciente.bd') -> leLoginPaciente ; iniciaLoginPaciente.
verificaIdPaciente :- exists_file('bd/paciente/id_paciente.bd') -> leIdPaciente ; iniciaIdPaciente.

/*
Inicializa a tabela dinamica de clinicas.
Campos esperados: ID, Nome, CNPJ, Endereço, Telefone, Horário de Funcionamento, Senha.
*/
iniciaClinica :-
    dynamic(clinica/7).

iniciaLoginClinica :-
    dynamic(login_clinica/2).

iniciaIdClinica :-
    asserta(id_clinica(0)).

nextIdClinica(N) :-
    id_clinica(X), retract(id_clinica(X)), N is X + 1, asserta(id_clinica(N)).

leClinica :- consult('bd/clinica/clinica.bd').
leIdClinica :- consult('bd/clinica/id_clinica.bd').
leLoginClinica :- consult('bd/clinica/login_clinica.bd').

verificaClinica :- exists_file('bd/clinica/clinica.bd') -> leClinica ; iniciaClinica.
verificaLoginClinica :- exists_file('bd/clinica/login_clinica.bd') -> leLoginClinica ; iniciaLoginClinica.
verificaIdClinica :- exists_file('bd/clinica/id_clinica.bd') -> leIdClinica ; iniciaIdClinica.


/*
Inicializa a tabela dinamica de médicos.
Campos esperados: ID Clínica, ID, Nome, CPF, CRM, Especialidade, Telefone, Senha.
*/
iniciaMedico :-
    dynamic(medico/8).

iniciaLoginMedico :-
    dynamic(login_medico/2).

iniciaIdMedico :-
    asserta(id_medico(0)).

nextIdMedico(N) :-
    id_medico(X), retract(id_medico(X)), N is X + 1, asserta(id_medico(N)).

leMedico :- consult('bd/medico/medico.bd').
leIdMedico :- consult('bd/medico/id_medico.bd').
leLoginMedico :- consult('bd/medico/login_medico.bd').

verificaMedico :- exists_file('bd/medico/medico.bd') -> leMedico ; iniciaMedico.
verificaLoginMedico :- exists_file('bd/medico/login_medico.bd') -> leLoginMedico ; iniciaLoginMedico.
verificaIdMedico :- exists_file('bd/medico/id_medico.bd') -> leIdMedico ; iniciaIdMedico.

iniciaExame :-
    dynamic(exame/4).


leExame :- consult('bd/exame/exame.bd').

verificaExame :- exists_file('bd/exame/exame.bd') -> leExame; iniciaExame.

iniciaLaudo :-
    dynamic(laudo/4).

leLaudo :- consult('bd/laudo/laudo.bd').

verificaLaudo :- exists_file('bd/laudo/laudo.bd') -> leLaudo ; iniciaLaudo.


iniciaReceita :-
    dynamic(receita/4).

leReceita :- consult('bd/receita/receita.bd').


verificaReceita :- exists_file('bd/receita/receita.bd') -> leReceita ; iniciaReceita.



iniciaSistema :- 
    verificaPaciente, verificaLoginPaciente, verificaIdPaciente, 
    verificaClinica, verificaIdClinica, verificaLoginClinica, 
    verificaMedico, verificaIdMedico, verificaLoginMedico, 
    verificaExame, 
    verificaLaudo, 
    verificaReceita.
