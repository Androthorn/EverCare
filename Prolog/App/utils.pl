:- module(utils, [prompt/2, promptString/2, autentica/3, mensagemEspera/0, promptOption/2, promptPassword/2,
                  tituloI/0, tituloInformacao/1, autenticaPaciente/3, autenticaClinica/3, autenticaMedico/3,
                  autenticaLoginClinica/2, autenticaLoginMedico/2, autenticaLoginPaciente/2, autenticaMedicoClinica/3,
                  horaValida/2, dataValida/1, horariosDisponiveis/3, tituloI/0, tituloInformacao/1,
                  imprimirListaComEspacos/1]).

:- use_module('../Models/model.pl').

prompt(Text, Value) :- promptString(Text, V), atom_number(V, Value).


promptString(Text, Value) :- read_pending_chars(user_input, _, _),
                             write(Text), flush_output(user),
                             read_line_to_string(user_input, Value).


promptOption(Text, Value) :- promptString(Text, V), string_upper(V, Value).


promptPassword(Text, Value) :- promptString(Text, V),
    (V = "" -> promptPassword(Text, Value) ;
    Value = V).


autenticaPaciente(ID, Senha, 1) :- model:login_paciente(ID, Senha), !.
autenticaPaciente(_, _, 0).

autenticaClinica(ID, Senha, 1) :- model:login_clinica(ID, Senha), !.
autenticaClinica(_, _, 0).

autenticaMedico(ID, Senha, 1) :- model:login_medico(ID, Senha), !.
autenticaMedico(_, _, 0).

mensagemEspera :- promptString('\n\nPressione qualquer tecla para continuar', _), tty_clear.

autenticaLoginPaciente(ID, 1) :- model:paciente(ID, _, _, _, _, _, _, _, _, _, _, _), !.
autenticaLoginPaciente(_, 0).

autenticaLoginClinica(ID, 1) :- model:clinica(ID, _, _, _, _, _, _), !.
autenticaLoginClinica(_, 0).

autenticaLoginMedico(ID, 1) :- model:medico(_, ID, _, _, _, _, _, _), !.
autenticaLoginMedico(_, 0).

autenticaMedicoClinica(IDC, IDM, 1) :- model:medico(IDC, IDM, _, _, _, _, _, _), !.
autenticaMedicoClinica(_, _, 0).

dataValida(Date) :-
    atomic_list_concat(DateList, '/', Date),
    maplist(atom_number, DateList, [Day, Month, Year]),
    Day >= 1, Day =< 31,
    Month >= 1, Month =< 12,
    Year >= 2024.

horaValida(Hour, Horarios) :-
    member(Hour, Horarios).

consultasDoMedicoNodia(IDM, Dia, Horario) :-
    model:consulta(_, _, IDM, _, Dia, Horario, _).

horariosDisponiveis(IDM, Dia, HorariosDisponiveis) :-
    Horarios = ["08:00", "09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00"],
    findall(Hora, (member(Hora, Horarios),
                   \+ consultasDoMedicoNodia(IDM, Dia, Hora)), HorariosDisponiveis).


imprimirListaComEspacos([]).
imprimirListaComEspacos([H|T]) :-
    write(H),
    write(' '),
    imprimirListaComEspacos(T).

% Exemplo de uso:
imprimirListaComEspacos(Horarios).


tituloI :-
    writeln( '-------------------------------------------------'),
    writeln( '------------------- EVERCARE --------------------'),
    writeln( '-------------------------------------------------').

tituloInformacao(Informa) :-
    writeln('-------------------------------------------------'),
    format('EVERCARE - ~s~n', [Informa]),
    writeln('-------------------------------------------------').