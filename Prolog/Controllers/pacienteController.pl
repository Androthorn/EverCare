:-module(paciente, [verReceita/1, verLaudo/1, verExame/1, validaIDPaciente/1,
                    verConsultaP/1, buscarClinica/1, buscarMedico/1, buscarClinicaPorPlano/1,
                    buscarClinicaAgendamento/1, verFila/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').



avaliaMedico( IdPac, IdMed, Nota, Comentario) :-
    criaAvaliacao([IdPac, IdMed, Nota, Comentario], Avaliacao),
    showAvaliacao(Avaliacao).

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


verConsultaP(IDPac) :- forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C), 
            show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).  

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

verFila(ID, IDPac, Posicao) :-
    model:fila(ID, IdClinica, IdMedico, Fila),
    utils:getPacienteID(IDPac, Nome),
    nth1(Posicao, Fila, Nome).
