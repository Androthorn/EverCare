:- module(clinica, [verAgendamentoClin/1, verMedicos/1, verPaciente/1, visualizaPacientes/1, visualizarInformacaoClinica/1, getClinicaName/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').


% Função para contar a quantidade de consultas, médicos e pacientes de uma clínica
contarInformacoesClinica(IdClinica, NumConsultas, NumMedicos, NumPacientes,RankingMedicos) :-
    % Contagem de consultas
    findall(IdCons, model:consulta(IdCons, IdClinica, _, _, _, _, _, _), Consultas),
    length(Consultas, NumConsultas),
    % Contagem de médicos
    findall(IdMedico, model:medico(IdClinica, IdMedico, _, _, _, _, _, _), Medicos),
    length(Medicos, NumMedicos),
    % Contagem de pacientes
    findall(IdPac, model:consulta(_, IdClinica, _, IdPac, _, _, _, _), Pacientes),
    list_to_set(Pacientes, PacientesUnicos),
    length(PacientesUnicos, NumPacientes).
     % Obter o número de consultas realizadas por cada médico
    findall(IdMedico-NumCons, (
        member(IdMedico, Medicos),
        findall(IdCons, model:consulta(IdCons, IdClinica, IdMedico, _, _, _, _, _), ConsultasMedico),
        length(ConsultasMedico, NumCons),
        format('Médico ~w: ~w consultas~n', [IdMedico, NumCons]) % Mensagem de depuração
    ), ConsultasPorMedico),
    writeln('Consultas por médico:'), writeln(ConsultasPorMedico), % Mensagem de depuração
     % Ordenar a lista de médicos pelo número de consultas (em ordem decrescente)
    keysort(ConsultasPorMedico, Sorted),
    reverse(Sorted, RankingMedicos).


getClinicaName(IdClinica, Clinicas, NomeClinica) :-
    nth1(IdClinica, Clinicas, Clinica),
    getNomeClinica(Clinica, NomeClinica).

getNomeClinica(clinica(IdClinica, NomeClinica, _), NomeClinica).  

verAgendamentoClin(IdClinica) :-
    forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C),
           show:showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C))).

visualizaPacientes(IdClinica) :-
    findall(IdPac, (model:consulta(_, IdClinica, _, IdPac, Data, Hora, Queixa, C)), L),
    list_to_set(L, S),
    foreach(member(IdP, S), showP(IdP)).
showP(IdP) :-
    model:paciente(IdP, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _),
    show:showPaciente(model:paciente(IdP, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _)).

verPaciente(IdClinica) :-
    forall(model:consulta(IdCons, IdClinica, IdMedico, IDPac, DataConsulta, HoraConsulta, Queixas, C),
           show:showPaciente(model:paciente(IDPac, Nome, CPF, DataNascimento, Sexo, Endereco, TipoSanguineo, Plano, Cardiopata, Hipertenso, Diabetico, _))).

verMedicos(IdClinica) :-
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, _),
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Telefone, Endereco, _))).


