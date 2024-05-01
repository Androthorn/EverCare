:- module(show, [showAvaliacao/1, showChat/1, showClinica/1, showConsulta/1, showExame/1, showFila/1, showLaudo/1, showMedico/1, showPaciente/1, showReceita/1]).
:- use_module('../Models/model.pl').

showAvaliacao(avaliacao(IdAvaliacao, IdPac, IdMed, Nota, Comentario)) :-
    format('-------------------~n', []),
    format('ID Avaliacao: ~w~n', [IdAvaliacao]),
    format('Paciente: ~w~n', [IdPac]),
    format('Médico: ~w~n', [IdMed]),
    format('Nota: ~w~n', [Nota]),
    format('Comentário: ~w~n', [Comentario]),
    format('-------------------~n', []).

showChat(chat(Id, IdPaciente, IdMedico, Mensagens)) :-
    format('----------------------------~n', []),
    format('CHAT ~w~n', [Id]),
    format('Paciente: ~w~n', [IdPaciente]),
    format('Médico: ~w~n', [IdMedico]),
    format('Mensagens: ~w~n', [Mensagens]).

showClinica(clinica(Id, Nome, Endereco, Planos, MetodoAgendamento, Contato, _)) :-
    format('----------------------------~n', []),
    format('Clinica  ~w~n', [Id]),
    format('Nome: ~w~n', [Nome]),
    format('Endereço: ~w~n', [Endereco]),
    format('Planos: ~w~n', [Planos]),
    format('Método de Agendamento: ~w~n', [MetodoAgendamento]),
    format('Contato: ~w~n', [Contato]),
    format('----------------------------~n', []).

showConsulta(consulta(IdCons, IdPaciente, IdClinica, IdMedico, DataConsulta, HoraConsulta, Queixas, Confirmado)) :-
    format('-------------------~n', []),
    format('Id da Consulta: ~w~n', [IdCons]),
    format('Id do paciente: ~w~n', [IdPaciente]),
    format('Id da Clínica: ~w~n', [IdClinica]),
    format('Id do Médico: ~w~n', [IdMedico]),
    format('Data da consulta: ~w~n', [DataConsulta]),
    format('Hora da consulta: ~w~n', [HoraConsulta]),
    format('Queixas: ~w~n', [Queixas]),
    format('Confirmado: ~w~n', [Confirmado]),
    format('-------------------~n', []).

showExame(exame( IdPaciente, IdMedico, Tipo)) :-
    format('----------------------------~n', []),
    format('Id do Paciente: ~w~n', [IdPaciente]),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Tipo do exame: ~w~n', [Tipo]).

showFila(fila(Id, IdClinica, IdMedico, Fila)) :-
    format('----------------------------~n', []),
    format('FILA ~w~n', [Id]),
    format('Clínica: ~w~n', [IdClinica]),
    format('Médico: ~w~n', [IdMedico]),
    format('Fila: ~w~n', [Fila]).

showLaudo(laudo( IdMedico, IdPaciente, Resultado)) :-
    format('----------------------------~n', []),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Id do Paciente: ~w~n', [IdPaciente]),
    format('Resultado: ~w', [Resultado]).

showMedico(medico(Clinica, Id, Nome, CRM, Especialidade, _, _)) :-
    format('----------------------------~n', []),
    format('Médico ~w~n', [Id]),
    format('Nome: ~w~n', [Nome]),
    format('CRM: ~w~n', [CRM]),
    format('Clínica: ~w~n', [Clinica]),
    format('Especialidade: ~w~n', [Especialidade]),
    format('-------------------~n', []).

showPaciente(paciente(Id, Nome, Cpf, DataNascimento, Sexo, Endereco, TipoSanguineo, Cardiopata, Hipertenso, Diabetico, _)) :-
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

showReceita(receita( IdMedico, IdPaciente, Texto)) :-
    format('----------------------------~n', []),
    format('Id do Médico responsável: ~w~n', [IdMedico]),
    format('Paciente: ~w~n', [IdPaciente]),
    format('Remédios:~n~w', [Texto]).
