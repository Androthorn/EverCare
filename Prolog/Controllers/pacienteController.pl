:- module(paciente, [validaIDPaciente/1]).
:- use_module('../Models/model.pl').

validaIDPaciente(ID) :-
    model:paciente(ID, _, _, _, _, _, _, _, _, _, _,_), !.
validaIDPaciente(_, _) :-
    false.
