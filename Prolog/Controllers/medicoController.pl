:- module(medico, [verConsulta/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verConsulta(IDMed) :- 
    forall(model:consulta(IdCons, IdClinica, IDMed, IdPac, DataConsulta, HoraConsulta, Queixas), 
           show:showConsulta(model:consulta(IdCons, IdClinica, IDMed, IdPac, DataConsulta, HoraConsulta, Queixas))).
