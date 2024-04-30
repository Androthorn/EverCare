:- module(medico, [emitirReceita/2, emitirLaudo/2, solicitarExame/2]).

:- use_module('../Models/model.pro').
:- use_module('../Persistence/persistence.pro').

emitirLaudo(IdMed, IdPaciente) :- 
     utils:promptString('Insira o texto do laudo > ', Texto),
    assertz(model:laudo(IdMed, IdPaciente, Texto)), 
    persistence:escreveLaudo. 

emitirReceita(IdMed, IdPaciente) :- 
     utils:promptString('Insira o texto da Receita > ', Texto), 
    assertz(model:receita(IdMed, IdPaciente, Texto)), 
    persistence:escreveReceita.

solicitarExame(IdMed, IdPaciente) :- 
    utils:promptString('Insira o texto do Exame > ', Texto), 
    assertz(model:exame( IdMed, IdPaciente, Texto)), 
    persistence:escreveExame.