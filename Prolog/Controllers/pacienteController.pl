:-module(paciente, [verReceita/1, verLaudo/1, verExame/1, validaIDPaciente/1,
                    verConsultaP/1, buscarClinica/1, buscarMedico/1, buscarClinicaPorPlano/1,
                    buscarClinicaAgendamento/1, verFila/1, buscarEspecialidade/1, buscarPorSintoma/1]).

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

% buscarClinica(NomeClinica) :-
%     forall(
%         model:clinica(ID, NomeClinica, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _),
%         (
%             show:showClinica(model:clinica(ID, NomeClinicaModel, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _))
%         )
%     ).

buscarClinica(NomeClinica) :-
    string_lower(NomeClinica, NomeClinicaLowerCase), % Convertendo o nome da clínica de entrada para minúsculas
    findall(
        Clinica,
        (
            model:clinica(ID, NomeClinicaModel, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _),
            string_lower(NomeClinicaModel, NomeClinicaModelLowerCase), % Convertendo o nome da clínica armazenado no banco de dados para minúsculas
            NomeClinicaModelLowerCase = NomeClinicaLowerCase,
            Clinica = model:clinica(ID, NomeClinicaModel, CNPJ, Endereco, Planos, MetodoAgendamento, Horario, Contato, _)
        ),
        Clinicas
    ),
    mostrarClinicas(Clinicas).

mostrarClinicas([]).
mostrarClinicas([Clinica|Resto]) :-
    show:showClinica(Clinica),
    mostrarClinicas(Resto).

buscarPorSintoma(SintomaU) :-
    string_lower(SintomaU, Sintoma),
    (
        (
            sub_atom(Sintoma, _, _, _, 'dor nas costas');
            sub_atom(Sintoma, _, _, _, 'dor lombar');
            sub_atom(Sintoma, _, _, _, 'dor na mão');
            sub_atom(Sintoma, _, _, _, 'dor no pé');
            sub_atom(Sintoma, _, _, _, 'dor no ombro')
        ) -> buscarEspecialidade(Ortopedista);

        (
            sub_atom(Sintoma, _, _, _, 'enxaqueca');
            sub_atom(Sintoma, _, _, _, 'dor de cabeça')
        ) -> buscarEspecialidade(Neurologista),!;

        (
            sub_atom(Sintoma, _, _, _, 'dor de garganta');
            sub_atom(Sintoma, _, _, _, 'nariz entupido');
            sub_atom(Sintoma, _, _, _, 'sinusite');
            sub_atom(Sintoma, _, _, _, 'dor de ouvido')
        ) -> buscarEspecialidade(Otorrinolaringologista),!;

        (
            sub_atom(Sintoma, _, _, _, 'menstruação desrregulada');
            sub_atom(Sintoma, _, _, _, 'gravidez');
            sub_atom(Sintoma, _, _, _, 'cólica')
        ) -> buscarEspecialidade(Ginecologista), !;

        (
            sub_atom(Sintoma, _, _, _, 'espinhas');
            sub_atom(Sintoma, _, _, _, 'queda de cabelo');
            sub_atom(Sintoma, _, _, _, 'mancha na pele')
        ) -> buscarEspecialidade(Dermatologista), !;

        (
            sub_atom(Sintoma, _, _, _, 'desconforto abdominal');
            sub_atom(Sintoma, _, _, _, 'azia');
            sub_atom(Sintoma, _, _, _, 'gastrite')
        ) -> buscarEspecialidade(Gastroenterologista), !;

        
        (
            sub_atom(Sintoma, _, _, _, 'pressão alta');
            sub_atom(Sintoma, _, _, _, 'pressão baixa')
        ) -> buscarEspecialidade(Cardiologista), !;

        (
            sub_atom(Sintoma, _, _, _, 'ansiedade');
            sub_atom(Sintoma, _, _, _, 'depressão')
        ) -> buscarEspecialidade(Psiquiatra), !;

        (
            sub_atom(Sintoma, _, _, _, 'visão embaçada');
            sub_atom(Sintoma, _, _, _, 'olho vermelho');
            sub_atom(Sintoma, _, _, _, 'coceira nos olhos')
        ) -> buscarEspecialidade(Oftalmologista), !;

        (
            sub_atom(Sintoma, _, _, _, 'queda de pressão');
            sub_atom(Sintoma, _, _, _, 'desmaio')
        ) -> buscarEspecialidade(Cardiologista), !;

        (
            sub_atom(Sintoma, _, _, _, 'dor nos rins');
            sub_atom(Sintoma, _, _, _, 'sangue na urina');
            sub_atom(Sintoma, _, _, _, 'dificuldade para urinar')
        ) -> buscarEspecialidade(Urologista), !;

        write('Não foi possível encontrar uma especialidade para o sintoma informado.'), !
    ).


buscarEspecialidade(Especialidade) :-
    forall(
        model:medico(Clinica, Id, Nome, CRM, Especialidade, Rede, Nota,_),
        show:showMedico(model:medico(Clinica, Id, Nome, CRM, Especialidade, Rede, Nota,_))
    ).

buscarMedico(Nome) :-
    forall(
        model:medico(Clinica, Id, Nome, CRM, Especialidade, Rede, Nota,_),
        show:showMedico(model:medico(Clinica, Id, Nome, CRM, Especialidade, Rede, Nota,_))
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
