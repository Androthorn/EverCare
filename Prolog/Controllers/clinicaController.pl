:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

verPaciente(IdClinica) :-
    findall(IDPac, model:consulta(_, IdClinica, _, IDPac, _, _, _, _), PacientesConsulta),
    list_to_set(PacientesConsulta, PacientesFiltrados),
    getPacientes(PacientesFiltrados, Pacientes),
    showPacientes(Pacientes).

getPacientes([], []).
getPacientes([IDPac|T], [Paciente|Pacientes]) :-
    model:paciente(IDPac, Nome, Cpf, DataNascimento, Sexo, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _, _),
    Paciente = paciente(IDPac, Nome, Cpf, DataNascimento, Sexo, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico),
    getPacientes(T, Pacientes).

showPacientes([]).
showPacientes([Paciente|T]) :-
    showPaciente(Paciente),
    showPacientes(T).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha), 
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha))).
