:- module(utils, [prompt/2, promptString/2, autentica/3, mensagemEspera/0, promptOption/2, promptPassword/2,
                  tituloI/0, tituloInformacao/1, autenticaPaciente/3, autenticaClinica/3]).

:- use_module('../Models/model.pl').

prompt(Text, Value) :- promptString(Text, V), atom_number(V, Value).


promptString(Text, Value) :- read_pending_chars(user_input, _, _),
                             write(Text), flush_output(user),
                             read_line_to_string(user_input, Value).


promptOption(Text, Value) :- promptString(Text, V), string_upper(V, Value).


promptPassword(Text, Value) :- promptString(Text, V),
    (V = "" -> promptPassword(Text, Value) ;
    Value = V).


autentica(ID, Senha, Tipo) :- model:logins(ID, Senha, Tipo), !.
autentica(_, _, Tipo) :- Tipo is -1.

autenticaPaciente(ID, Senha, 1) :- model:login_paciente(ID, Senha), !.
autenticaPaciente(_, _, 0) :- false.

autenticaClinica(ID, Senha, 1) :- model:login_clinica(ID, Senha), !.
autenticaClinica(_, _, 0) :- false.

mensagemEspera :- promptString('\n\nPressione qualquer tecla para continuar', _), tty_clear.

tituloI :-
    writeln( '-------------------------------------------------'),
    writeln( '------------------- EVERCARE --------------------'),
    writeln( '-------------------------------------------------').

tituloInformacao(Informa) :-
    writeln('-------------------------------------------------'),
    format('EVERCARE - ~s~n', [Informa]),
    writeln('-------------------------------------------------').