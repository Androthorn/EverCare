:-module(paciente, [verReceita/1, verLaudo/1, verExame/1, validaIDPaciente/1, verConsulta/1, paciente_logado/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').

/*
    Consulta as receitas de um paciente.
    @param IDPac ID do paciente.
*/
verReceita(IdPaciente) :- forall(model:receita(IdMedico, IdPaciente, Texto), show:showReceita(model:receita(IdMedico, IdPaciente, Texto))).
/*
    Consulta os medicamentos de um paciente.
    @param IDPac ID do paciente.
*/
verLaudo(IDPac) :- forall(model:laudo(IdMed, IdPac, texto), show:showLaudo(model:laudo(IdMed, IdPac, texto))).

/*
    Consulta os exames de um paciente.
    @param IDPac ID do paciente.
*/
verExame(IDPac) :- forall(model:exame(IdMed, IdPac, tipo), show:showExame(model:exame(IdMed, IdPac, tipo))).


verConsulta(IDPac) :- 
    forall(model:consulta(IdCons, IDPac, IdClinica, IdMedico, DataConsulta, HoraConsulta, Queixas), 
           show:showConsultaPaciente(model:consulta(IdCons, IDPac, IdClinica, IdMedico, DataConsulta, HoraConsulta, Queixas))).
