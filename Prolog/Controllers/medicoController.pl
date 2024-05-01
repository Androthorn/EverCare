:- module(medico, [emitirReceita/2, emitirLaudo/2, solicitarExame/2, validaIDMedico/1]).

:- use_module('../Models/model.pl').
:- use_module('../Persistence/persistence.pl').
validaIDMedico(ID) :-
    model:medico(ID, _, _, _, _, _, _, _, _, _, _),
    !.
validaIDMedico(_, _) :-
    false.

emitirLaudo(IdMed, IdPaciente) :- 
    utils:promptString('Insira o texto do laudo > ', Texto),
    assertz(model:laudo(IdMed, IdPaciente, Texto)), 
    persistence:saveLaudo. 



emitirReceita(IdMed, IdPaciente) :- 
    utils:promptString('Insira o texto da Receita > ', Texto), 
    assertz(model:receita(IdMed, IdPaciente, Texto)), 
    persistence:saveReceita.

solicitarExame(IdMed, IdPaciente) :- 
    utils:promptString('Insira o texto do Exame > ', Texto), 
    assertz(model:exame(IdMed, IdPaciente, Texto)), 
    persistence:saveExame.
