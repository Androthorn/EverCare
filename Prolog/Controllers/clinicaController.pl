:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/1, verFilas/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

verAgendamentoClin(IdClinica) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

verPaciente(IdClinica) :-
    writeln('Pacientes com consulta na clínica:'),
    setof(IdPaciente, Data^Hora^Queixas^IdCons^IdMedico^Consulta^model:consulta(IdCons, IdClinica, IdMedico, IdPaciente, Data, Hora, Queixas, Consulta), PacientesUnicos),
    forall(member(IdPac, PacientesUnicos),
           (model:paciente(IdPac, Nome, CPF, Sexo, DataNascimento, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _, _),
            show:showPaciente(model:paciente(IdPac, Nome, CPF, Sexo, DataNascimento, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _, _)))).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha), 
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, Senha))).

verFilas(IdClinica) :-
    forall(model:fila(IdFila, IdClinica, IdMedico, Fila), 
           show:showFila(model:fila(IdFila, IdClinica, IdMedico, Fila))).