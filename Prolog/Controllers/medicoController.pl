:- module(medico, [emitirReceita/2, emitirLaudo/2, solicitarExame/2]).

:- use_module('../Models/model.pro').
:- use_module('../Persistence/persistence.pro').

emitirLaudo(IdMed, IdPaciente) :- 
    model:nextId(Id), 
    persistence:escreveId, 
    utils:promptString('Insira o texto do laudo > ', Texto),
    assertz(model:laudo(Id, IdMed, IdPaciente, Texto)), 
    persistence:escreveLaudo. 

emitirReceita(IdMed, IdPaciente) :- 
    model:nextId(Id), 
    persistence:escreveId, 
    utils:promptString('Insira o texto da Receita > ', Texto), 
    assertz(model:receita(Id, IdMed, IdPaciente, Texto)), 
    persistence:escreveReceita.

solicitarExame(IdMed, IdPaciente) :- 
    model:nextId(Id), 
    persistence:escreveId, 
    utils:promptString('Insira o texto do Exame > ', Texto), 
    assertz(model:exame(Id, IdMed, IdPaciente, Texto)), 
    persistence:escreveExame.