:- module(model, [iniciaPaciente/0, iniciaIdPaciente/0, iniciaLoginPaciente/0, nextIdPaciente/1, iniciaSistema/0,
                iniciaClinica/0, iniciaIdClinica/0, iniciaLoginClinica/0, nextIdClinica/1]).

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

iniciaSistema :- 
    verificaPaciente, verificaLoginPaciente, verificaIdPaciente, verificaClinica, verificaIdClinica, verificaLoginClinica.
