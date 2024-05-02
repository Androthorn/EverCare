:- module(clinica, [verAgendamentos/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').
:- use_module('../Controllers/persistence.pl').

verAgendamentos(IdClin) :-
    forall(model:consulta(IdAgend, IdClin, IdMed, IdPac, DataAgend, HoraAgend, Queixas),
           show:showConsulta(model:consulta(IdAgend, IdClin, IdMed, IdPac, DataAgend, HoraAgend, Queixas))).