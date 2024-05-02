:- module(medico_controller, [verConsulta/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verConsulta(IDMed) :- 
    forall(model:consulta(IdCons, IdClinica, IDMed, IdPac, DataConsulta, HoraConsulta, Queixas), 
           show:showConsultaMedico(model:consulta(IdCons, IdClinica, IDMed, IdPac, DataConsulta, HoraConsulta, Queixas))).
