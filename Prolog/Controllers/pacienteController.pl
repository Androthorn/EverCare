:-module(paciente, [verReceita/1, verLaudo/1, verExame/1, validaIDPaciente/1, verConsulta/1, paciente_logado/1, buscarClinica/1, bucarMedico/1, buscarClinicaPorPlano/1, buscarClinicaAgendamento/1]).

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
verLaudo(IDPac) :- forall(model:laudo(IdMed, IDPac, texto), show:showLaudo(model:laudo(IdMed, IDPac, texto))).

/*
    Consulta os exames de um paciente.
    @param IDPac ID do paciente.
*/
verExame(IDPac) :- forall(model:exame(IdMed, IDPac, tipo), show:showExame(model:exame(IdMed, IDPac, tipo))).


verConsulta(IDPac) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas))).  

chatsAtivos(IDPac) :- forall(model:chat(Id, IDPac, IdMedico, Mensagens), show:showChat(model:chat(Id, IDPac, IdMedico, Mensagens))).

buscarClinica(NomeClinica) :-
    forall(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato,_),
           (show:showClinica(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _)), !)).


buscarMedico(Nome) :-
    forall(
        model:medico(Clinica, Id, Nome, CRM, Especialidade, _, _,_),
        show:showMedico(model:medico(Clinica, Id, Nome, CRM, Especialidade, _, _,_))
    ).

buscarClinicaPorPlano(Planos) :-
    forall(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato,_),
           show:showClinica(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _))).

buscarClinicaAgendamento(MetodoAgendamento) :-
     forall(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato,_),
           show:showClinica(model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _))).