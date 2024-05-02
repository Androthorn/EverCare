:- module(model, [iniciaPaciente/0, iniciaIdPaciente/0, iniciaLoginPaciente/0, nextIdPaciente/1,
                  iniciaClinica/0, iniciaIdClinica/0, iniciaLoginClinica/0, nextIdClinica/1, 
                  iniciaMedico/0, iniciaIdMedico/0, iniciaLoginMedico/0, nextIdMedico/1, 
                  iniciaConsulta/0, iniciaIdConsulta/0, nextIdConsulta/1 ,
                  iniciaReceita/0, iniciaLaudo/0, iniciaExame/0,
                  iniciaChat/0, iniciaIdChat/0, nextIdChat/1,
                  iniciaSistema/0]).

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
Campos esperados: ID, Nome, CNPJ, Endereço, Planos, Metodo de Agendamento, Horário de Funcionamento, Contato, Senha.
*/
iniciaClinica :-
    dynamic(clinica/9).

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

/*
Inicializa a tabela dinamica de receitas.
Campos esperados: ID Médico, ID Paciente, Texto.
*/
iniciaReceita :-
    dynamic(receita/3).

leReceita :- consult('bd/pos_consulta/receita.bd').
verificaReceita :- exists_file('bd/pos_consulta/receita.bd') -> leReceita ; iniciaReceita.

/*
Inicializa a tabela dinamica de laudos.
Campos esperados: ID Médico, ID Paciente, Texto.
*/
iniciaLaudo :-
    dynamic(laudo/3).

leLaudo :- consult('bd/pos_consulta/laudo.bd').
verificaLaudo :- exists_file('bd/pos_consulta/laudo.bd') -> leLaudo ; iniciaLaudo.

/*
Inicializa a tabela dinamica de exames.
Campos esperados: ID Médico, ID Paciente, Texto.
*/
iniciaExame :-
    dynamic(exame/3).

leExame :- consult('bd/pos_consulta/exame.bd').
verificaExame :- exists_file('bd/pos_consulta/exame.bd') -> leExame ; iniciaExame.

/*

Inicializa a tabela de consultas.
Os campos são: Id, IdClinica, IdMedico, IdPaciente, DataConsulta, HoraConsulta, Queixas, Confirmação.

*/

iniciaConsulta :- dynamic(consulta/8).

iniciaIdConsulta :-
    asserta(id_consulta(0)).

nextIdConsulta(N) :-
    id_consulta(X), retract(id_consulta(X)), N is X + 1, asserta(id_consulta(N)).

leConsulta :- consult('bd/consulta/consulta.bd').
verificaConsulta :- 
    exists_file('bd/consulta/consulta.bd') -> leConsulta ; iniciaConsulta.
verificaIdConsulta :- 
    exists_file('bd/consulta/id_consulta.bd') -> leIdConsulta ; iniciaIdConsulta.
leIdConsulta :- consult('bd/consulta/id_consulta.bd'). 

/*
Inicializa a tabela dinâmica de chats.
Campos esperados: ID, ID Paciente, ID Médico, Mensagens.
*/
iniciaChat :-
    dynamic(chat/4).
iniciaIdChat :-
    asserta(id_chat(0)).

nextIdChat(N) :-
    id_chat(X), retract(id_chat(X)), N is X + 1, asserta(id_chat(N)).

leIdChat :- consult('bd/chat/id_chat.bd').
leChat :- consult('bd/chat/chat.bd').

verificaIdChat :- exists_file('bd/chat/id_chat.bd') -> leIdChat ; iniciaIdChat.
verificaChat :- exists_file('bd/chat/chat.bd') -> leChat ; iniciaChat.

/*
Inicializa todas as tabelas dinâmicas do sistema.
*/
iniciaSistema :- 
    verificaPaciente, verificaLoginPaciente, verificaIdPaciente, 
    verificaClinica, verificaIdClinica, verificaLoginClinica, 
    verificaMedico, verificaIdMedico, verificaLoginMedico,
    verificaConsulta, verificaIdConsulta,
    verificaLaudo, verificaReceita, verificaExame,
    verificaChat, verificaIdChat.
