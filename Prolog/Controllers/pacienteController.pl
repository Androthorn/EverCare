module(paciente, [validaIDPaciente/1]).

:- use_module('../Models/model.pl').
:- use_module('../Persistence/persistence.pl').

validaIDPaciente(ID) :- model:paciente(ID, _, _, _, _, _, _, _, _, _, _).