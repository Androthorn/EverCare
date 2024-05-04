:- module(show, [showAvaliacao/1, showChat/1, showClinica/1, showConsulta/1, 
            showExame/1, showFila/1, showLaudo/1, showMedico/1, showPaciente/1, showReceita/1]).
:- use_module('../Models/model.pl').

% % # showAvaliacao(model:avaliacao(IdAvaliacao, IdPac, IdMed, Nota, Comentario)) :-
% % #     format('-------------------~n', []),
% % #     format('ID Avaliacao: ~w~n', [IdAvaliacao]),
% % #     format('Paciente: ~w~n', [IdPac]),
% % #     format('Médico: ~w~n', [IdMed]),
% % #     format('Nota: ~w~n', [Nota]),
% % #     format('Comentário: ~w~n', [Comentario]),
% % #     format('-------------------~n', []).

 showChat(model:chat(Id, IdPaciente, IdMedico, Mensagens)) :-
     format('----------------------------~n', []),
     format('CHAT ~w~n', [Id]),
     format('Paciente: ~w~n', [IdPaciente]),
     format('Médico: ~w~n', [IdMedico]),
     format('Mensagens: ~w~n', [Mensagens]).

showFila(model:fila(Id, IdClinica, IdMedico, Fila)) :-
    format('----------------------------~n', []),
    format('FILA ~w~n', [Id]),
    format('Clínica: ~w~n', [IdClinica]),
    format('Médico: ~w~n', [IdMedico]),
    format('Fila: ~w~n', [Fila]).

showClinica(model:clinica(Id, Nome, CNPJ, Endereco, Planos, MetodoAgendamento, Horarios, Contato, _)) :-
    format('----------------------------~n', []),
    format('Clinica  ~w~n', [Id]),
    format('Nome: ~w~n', [Nome]),
    format('CNPJ: ~w~n', [CNPJ]),
    format('Endereço: ~w~n', [Endereco]),
    format('Planos: ~w~n', [Planos]),
    format('Método de Agendamento: ~w~n', [MetodoAgendamento]),
    format('Horários de Funcionamento: ~w~n', [Horarios]),
    format('Contato: ~w~n', [Contato]),
    format('----------------------------~n', []).

showConsulta(model:consulta(IdCons, IdClinica, IdMedico, IdPaciente, DataConsulta, HoraConsulta, Queixas, Confirmacao)) :-
    format('-------------------~n', []),
    format('Id da Consulta: ~w~n', [IdCons]),
    format('Id da Clinica: ~w~n', [IdClinica]),
    format('Id do Medico: ~w~n', [IdMedico]),
    format('Id do Paciente: ~w~n', [IdPaciente]), 
    format('Data da consulta: ~w~n', [DataConsulta]),
    format('Hora da consulta: ~w~n', [HoraConsulta]),
    format('Queixas: ~w~n', [Queixas]),
    format('Confirmação: ~w~n', [Confirmacao]),
    format('-------------------~n', []).

showExame(model:exame(IdMedico, IdPaciente, Texto)) :-
    format('----------------------------~n', []),
    format('Id do Paciente: ~w~n', [IdPaciente]),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Tipo do exame: ~w~n', [Texto]).

showLaudo(model:laudo(IdMedico, IdPaciente, Texto)) :-
    format('----------------------------~n', []),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Id do Paciente: ~w~n', [IdPaciente]),
    format('Resultado: ~w', [Texto]).

showMedico(model:medico(Clinica, Id, Nome, CRM, Especialidade, _, _,_)) :-
    format('----------------------------~n', []),
    format('Médico ~w~n', [Id]),
    format('Nome: ~w~n', [Nome]),
    format('CRM: ~w~n', [CRM]),
    format('Clínica: ~w~n', [Clinica]),
    format('Especialidade: ~w~n', [Especialidade]),
    format('-------------------~n', []).

showPaciente(model:paciente(Id, Nome, Cpf, DataNascimento, Sexo, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _)) :-
    format('-------------------~n', []),
    format('Id do Paciente: ~w~n', [Id]),
    format('Nome Completo: ~w~n', [Nome]),
    format('Cpf: ~w~n', [Cpf]),
    format('Data de nascimento: ~w~n', [DataNascimento]),
    format('Sexo: ~w~n', [Sexo]),
    format('Endereço: ~w~n', [Endereco]),
    format('Tipo sanguíneo: ~w~n', [TipoSanguineo]),
    format('Cardiopata? ~w~n', [Cardiopata]),
    format('Hipertenso? ~w~n', [Hipertenso]),
    format('Diabético? ~w~n', [Diabetico]),
    format('-------------------~n', []).

showReceita(model:receita(IdMedico, IdPaciente, Texto)) :-
    format('----------------------------~n', []),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Paciente: ~w~n', [IdPaciente]),
    format('Remédios:~n~w', [Texto]).

