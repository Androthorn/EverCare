:- module(clinica, [verAgendamentoClin/1, mapMedicoConsulta/2,verMedicos/1, verPaciente/1, visualizaPacientes/1, 
                    verFila/1, visualizarInformacaoClinica/1, getClinicaName/1, showRankingMedicos/1, showMedicosNota/1]).

:- use_module('../App/show.pl').
:- use_module('../Models/model.pl').
:- use_module('../App/utils.pl').



contarInformacoesClinica(IdClinica, NumConsultas, NumMedicos, NumPacientes,RankingMedicos, PorNota) :-
    
    findall(IdCons, model:consulta(IdCons, IdClinica, _, _, _, _, _, _), Consultas),
    length(Consultas, NumConsultas),
    
    findall(IdMedico, model:medico(IdClinica, IdMedico, _, _, _, _, _, _), Medicos),
    length(Medicos, NumMedicos),
   
    findall(IdPac, model:consulta(_, IdClinica, _, IdPac, _, _, _, _), Pacientes),
    list_to_set(Pacientes, PacientesUnicos),
    length(PacientesUnicos, NumPacientes),
   
    mapMedicoConsulta(IdClinica, RankingMedicos),
    mapMedicosNota(IdClinica, PorNota).

mapMedicosNota(IdClinica, Map) :-
    findall(Nota-IdMed,
            (model:medico(IdClinica, IdMed, _, _, _, _, Nota, _)),
            Pares),
    keysort(Pares, Sorted), 
    reverse(Sorted, Reversed), 
    maplist(swap_paire, Reversed, Map). 

swap_paire(Nota-IdMed, IdMed-Nota).

showMedicosNota([]).
showMedicosNota([IdMedico-Nota|Resto]) :-
    getMedicoID(IdMedico, NomeMedico),
    format('Médico: ~w - Nota: ~w~n', [NomeMedico, Nota]),
    showMedicosNota(Resto).


mapMedicoConsulta(IDClin, Map) :-
    findall(NumCons-IdMed,
            (model:medico(IDClin, IdMed, _, _, _, _, _, _),
             findall(IdCons, model:consulta(IdCons, IDClin, IdMed, _, _, _, _, _), Consultas),
             length(Consultas, NumCons)),
            Pares),
    keysort(Pares, Sorted), % Ordena os pares pela quantidade de consultas (NumCons)
    reverse(Sorted, Reversed), % Inverte a lista ordenada para obter a ordem decrescente
    maplist(swap_pair, Reversed, Map). % Troca a chave e o valor dos pares

% Predicado para trocar a ordem de um par (Chave-Valor) para (Valor-Chave)
swap_pair(NumCons-IdMed, IdMed-NumCons).

showRankingMedicos([]).
showRankingMedicos([IdMedico-NumCons|Resto]) :-
    getMedicoID(IdMedico, NomeMedico),
    format('Médico: ~w - Consultas: ~w~n', [NomeMedico, NumCons]),
    showRankingMedicos(Resto).

getMedicoID(IdMedico, NomeMedico) :-
    model:medico(_, IdMedico, Nome, _, _, _, _, _),
    NomeMedico = Nome.

getClinicaName(IdClinica, NomeClinica) :-
    model:clinica(IdClinica, Nome, _, _, _, _, _, _,_),
    NomeClinica = Nome.

verFila(IdClinica) :-
    forall(model:fila(ID, IdClinica, IdMedico, Fila), 
           show:showFila(model:fila(ID, IdClinica, IdMedico, Fila))).

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
    forall(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Rede, Nota, _),
           show:showMedico(model:medico(IdClinica, IdMed, Nome, CRM, Especialidade, Rede, Nota, _))).
