:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

verPaciente(IdClinica) :-
    forall(
        model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
        (
            model:paciente(IDPac, Nome, CPF, Sexo, DataNascimento, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _, _),
            show: showPaciente(paciente(IDPac, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _, _))
        )
    ).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha), 
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha))).
