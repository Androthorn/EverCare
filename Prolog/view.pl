:- encoding(utf8).

%
:- use_module('./App/utils.pl').
:- use_module('./Models/model.pl').
:- use_module('./Controllers/pacienteController.pl').
:- use_module('./Controllers/medicoController.pl').
:- use_module('./Controllers/clinicaController.pl').
:- use_module('./Controllers/persistence.pl').

begin :- model:iniciaSistema,
         main.

tituloI(Titulo, Resultado) :-
    string_length(Titulo, TamTitulo),
    NumTracos is (37 - TamTitulo) // 2,
    length(Tracos, NumTracos),
    maplist(=(''), Tracos, ['-']),
    string_chars(TracoExtra, ['-']),
    length(TracoFinal, 37 - NumTracos - TamTitulo - 1),
    maplist(=(''), TracoFinal, ['-']),
    string_concat(" -------------------------------------------------\n",
                  EspacoInicial),
    string_concat(EspacoInicial, Tracos, ParteTitulo1),
    string_concat(ParteTitulo1, " EVERCARE - ", ParteTitulo2),
    string_concat(ParteTitulo2, Titulo, ParteTitulo3),
    string_concat(ParteTitulo3, TracoFinal, ParteTitulo4),
    string_concat(ParteTitulo4, "\n -------------------------------------------------\n", Resultado).

/* Menu inicial. */

main :-
    writeln( '-------------------------------------------------'),
    writeln( '------------------- EVERCARE --------------------'),
    writeln( '-------------------------------------------------'),
    writeln('[P] - Paciente'),
    writeln('[C] - Clínica'),
    writeln('[M] - Médico'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "P" -> tty_clear, inicialPaciente;
      OP = "C" -> tty_clear, inicialPaciente;
      OP = "M" -> tty_clear, inicialPaciente;
      OP = "S" -> writeln('Saindo...');
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, main).

/* Menu de login do paciente. */
inicialPaciente :-
    tituloI('PACIENTE', Titulo),
    writeln(Titulo),
    writeln('[C] - Cadastrar'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, cadastraPaciente, tty_clear, inicialPaciente;
      OP = "L" -> tty_clear, loginPaciente;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialPaciente).

cadastraPaciente :-
    tituloI('CADASTRO DE PACIENTE', Titulo),
    writeln(Titulo),
    promptString('Nome > ', Nome),
    promptString('CPF > ', CPF),
    promptString('Sexo > ', Sexo),
    promptString('Data de Nascimento (dd/mm/aaaa) > ', DataNascimento),
    promptString('Endereço > ', Endereco),
    promptString('Tipo Sanguineo > ', Telefone),
    promptString('Plano de Saúde > ', PlanoSaude),
    promptString('Cardiopata (S ou N) > ', Cardiopata),
    promptString('Hipertenso (S ou N) > ', Hipertenso),
    promptString('Diabético (S ou N) > ', Diabetico),
    promptString('Senha > ', Senha),
    model:nextIdPaciente(IdPac),

    assertz(paciente(IdPac, Nome, CPF, Sexo, DataNascimento, Endereco, Telefone, PlanoSaude, Cardiopata, Hipertenso, Diabetico, Senha)),
    persistence:savePaciente,
    format('Paciente cadastrado com sucesso! Seu id é: ~d', [IdPac]).
    utils:mensagemEspera, tty_clear, loginPaciente.

loginPaciente() :-
    promptString('ID > ', ID),
    promptString('Senha > ', Senha),
    autenticaPaciente(ID, Senha, N),
    ( N =:= 1 -> tty_clear, menuPaciente(ID);
      writeln('Login ou senha inválidos'), utils:mensagemEspera, tty_clear, inicialPaciente).

menuPaciente(IdPac) :-
    tituloI('DASHBOARD PACIENTE', Titulo),
    write(Titulo),
    write('[B] Buscar'), nl,
    write('[M] Marcar Consulta'), nl,
    write('[V] Ver Agendamentos'), nl,
    write('[R] Ver Receitas / Laudos / Solicitação de Exames'), nl,
    write('[A] Avaliar Atendimento'), nl,
    write('[C] Chat'), nl,
    write('[F] Fila Virtual'), nl,
    write('[S] Sair'), nl,
    promptOption('Opção > ', OP),

    ( OP = "B" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "M" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "V" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "R" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "A" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "C" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "F" -> tty_clear, menuPaciente(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuPaciente(IdPac)).

inicialClinica :-
    tituloI('CLINICA', Titulo),
    writeln(Titulo),
    writeln('[C] - Cadastrar'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, cadastraClinica, tty_clear, inicialClinica;
      OP = "L" -> tty_clear, loginClinica;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialClinica).

cadastraClinica :-
    tituloI('CADASTRO DE CLINICA', Titulo),
    writeln(Titulo),

    promptString('Nome > ', Nome),
    promptString('CNPJ > ', CNPJ),
    promptString('Endereço > ', Endereco),
    promptString('Telefone > ', Telefone),
    promptString('Senha > ', Senha),
    model:nextIdClinica(IdClinica),
    assertz(clinica(IdClinica, Nome, CNPJ, Endereco, Telefone, Senha)),
    persistence:saveClinica,
    format('Clinica cadastrada com sucesso! Seu id é: ~d', [IdClinica]),
    utils:mensagemEspera, tty_clear, loginClinica.

loginClinica() :-
    promptString('ID > ', ID),
    promptString('Senha > ', Senha),
    autenticaClinica(ID, Senha, N),
    ( N =:= 1 -> tty_clear, menuClinica(ID);
      writeln('Login ou senha inválidos'), utils:mensagemEspera, tty_clear, inicialClinica).

