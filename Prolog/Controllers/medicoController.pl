:- module(medico_controller, [verConsulta/1, chatsAtivos/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verConsulta(IdMedico) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

chatsAtivos(IDMed) :- forall(model:chat(Id, IDPac, IDMed, Mensagens), show:showChat(model:chat(Id, IDPac, IDMed, Mensagens))).