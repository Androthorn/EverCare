:- module(medico_controller, [verConsulta/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verConsulta(IDMedico) :- 
    forall(model:consulta(IdCons, IDPac, IdClinica, IdMedico, DataConsulta, HoraConsulta, Queixas), 
           show:showConsultaMedico(model:consulta(IdCons, IDPac, IdClinica, IdMedico, DataConsulta, HoraConsulta, Queixas))).
