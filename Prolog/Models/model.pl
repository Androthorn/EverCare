:- module(model, [iniciaPaciente/0, iniciaIdPaciente/0, iniciaLoginPaciente/0, nextIdPaciente/1, iniciaSistema/0]).

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

iniciaSistema :- 
    verificaPaciente, verificaLoginPaciente, verificaIdPaciente.

verificaPaciente :- exists_file('bd/paciente/paciente.bd') -> lePaciente ; iniciaPaciente.
verificaLoginPaciente :- exists_file('bd/paciente/login_paciente.bd') -> leLoginPaciente ; iniciaLoginPaciente.
verificaIdPaciente :- exists_file('bd/paciente/id_paciente.bd') -> leIdPaciente ; iniciaIdPaciente.