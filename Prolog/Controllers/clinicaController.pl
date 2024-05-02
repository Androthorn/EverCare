:- module(clinica, [verAgendamentoClin/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  
