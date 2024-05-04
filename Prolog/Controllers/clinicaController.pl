:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/1, visualizaPacientes/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

visualizaPacientes(IdClinica) :-
    findall(IdPac, (model:consulta(_, IdClinica, _, IdPac, Data, Hora, Queixa, C)), L),
    list_to_set(L, S),
    foreach(member(IdP, S), showP(IdP)).

showP(IdP) :- model:paciente(IdP, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _),
              show:showPaciente(model:paciente(IdP, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _)).

verPaciente(IdClinica) :-
    forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
        show:showPaciente(model:paciente(IDPac, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _))).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, _), 
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, _))).
