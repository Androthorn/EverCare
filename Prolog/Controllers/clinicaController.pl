:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/4]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

verPaciente(_, [], [], "Não há pacientes nessa clínica").
verPaciente(_, [], _, "").
verPaciente(_, _, [], "").

verPaciente(IdClinica, Consultas, Pacientes, InfoPacientes) :-
    findall(IDPac, (member(consulta(_, IdClinica, _, IDPac, _, _, _, _), Consultas)), PacientesConsulta),
    list_to_set(PacientesConsulta, PacientesFiltrados),
    getPacientes(PacientesFiltrados, Pacientes, PacientesOK),
    showLista(PacientesOK, InfoPacientes).

getPacientes([], _, []).
getPacientes([IDPac|T], Pacientes, [Paciente|PacientesOK]) :-
    member(Paciente, Pacientes),
    paciente(IDPac, Paciente),
    getPacientes(T, Pacientes, PacientesOK).

showLista([], "").
showLista([Paciente|T], InfoPacientes) :-
    showPaciente(Paciente, InfoPaciente),
    showLista(T, Resto),
    string_concat(InfoPaciente, Resto, InfoPacientes).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha), 
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha))).
