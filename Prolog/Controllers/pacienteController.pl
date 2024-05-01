# :- module (paciente, [consultarReceitas/1]).

# :- use_module('../App/show.pl').
# :- use_module('../Models/model.pl').
# :- use_module('../App/utils.pl').

# /*
#     Consulta as receitas de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarReceitas(IDPac) :- forall(model:receita(Id, IdMed, IdPac, texto), show:showReceita(model:receita(Id, IdMed, IdPac, texto))).

# /*
#     Consulta os medicamentos de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarLaudo(IDPac) :- forall(model:laudo(Id, IdMed, IdPac, texto), show:showLaudo(model:laudo(Id, IdMed, IdPac, texto))).

# /*
#     Consulta os exames de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarExames(IDPac) :- forall(model:exame(Id, IdMed, IdPac, tipo), show:showExame(model:exame(Id, IdMed, IdPac, tipo))).
:- use_module('../Models/model.pl').
:- use_module('../Controllers/persistence.pl').
:- use_module('../App/utils.pl').
:- use_module('../App/show.pl').


# /* 
# Cria uma consulta.

# @param ID: id da consulta.
# @param IDClinica: id da clínica.
# @param IDMedico: id do médico.
# @param Data: data da consulta.
# @param Horario: horário da consulta.
# @param Queixa: queixa do paciente.
# */
# cadastraConsulta(IDClinica, IDMedico, Data, Horario, Queixa) :- 
#     assertz(model:consulta(ID, IDClinica, IDMedico, Data, Horario, Queixa)).
:- module(paciente, [validaIDPaciente/1]).
:- use_module('../Models/model.pl').

validaIDPaciente(ID) :-
    model:paciente(ID, _, _, _, _, _, _, _, _, _, _,_), !.
validaIDPaciente(_, _) :-
    false.
