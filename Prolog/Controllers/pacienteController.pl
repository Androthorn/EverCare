:- module (paciente, [cadastraConsulta/5]).
:- use_module('../Models/model.pl').
:- use_module('../Controllers/persistence.pl').
:- use_module('../App/utils.pl').
:- use_module('../App/show.pl').


/* 
Cria uma consulta.

@param ID: id da consulta.
@param IDClinica: id da clínica.
@param IDMedico: id do médico.
@param Data: data da consulta.
@param Horario: horário da consulta.
@param Queixa: queixa do paciente.
*/
cadastraConsulta(IDClinica, IDMedico, Data, Horario, Queixa) :- 
    assertz(model:consulta(ID, IDClinica, IDMedico, Data, Horario, Queixa)).