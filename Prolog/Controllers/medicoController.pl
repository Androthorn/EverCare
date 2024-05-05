:- module(medico, [verConsultaM/1, chatsAtivos/1, atualizarNota/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').
:- use_module('../Controllers/persistence.pl').

verConsultaM(IdMedico) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

chatsAtivos(IDMed) :- forall(model:chat(Id, IDPac, IDMed, Mensagens), show:showChat(model:chat(Id, IDPac, IDMed, Mensagens))).


atualizarNota(IdMedico) :-
    findall(Nota, model:avaliacao(_, IdMedico, Nota, _), Notas),
    sumlist(Notas, SomaNotas),
    length(Notas, NumNotas),
    NotaFinal is SomaNotas / NumNotas,
    
    retract(model:medico(IdClinica, IdMedico, Nome, CRM, Especialidade, Rede, _, _)),
    assertz(model:medico(IdClinica, IdMedico, Nome, CRM, Especialidade, Rede, NotaFinal, _)),
    persistence:saveMedico.