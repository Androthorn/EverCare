:- encoding(utf8).

%
:- use_module('./App/utils.pl').
:- use_module('./Models/model.pl').
:- use_module('./Controllers/persistence.pl').

begin :- model:iniciaSistema,
         main.

main :-
    tty_clear,
    utils:tituloI,
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

inicialPaciente :-
    tty_clear,
    utils:tituloInformacao('PACIENTE'),
    writeln('[C] - Cadastrar'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, cadastraPaciente;
      OP = "L" -> tty_clear, loginPaciente;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialPaciente).

cadastraPaciente :-
    tty_clear,
    utils:tituloInformacao('CADASTRO DE PACIENTE'),
    promptString('Nome > ', Nome),
    promptString('CPF > ', CPF),
    promptString('Sexo > ', Sexo),
    promptString('Data de Nascimento (dd/mm/aaaa) > ', DataNascimento),
    promptString('Endereço > ', Endereco),
    promptString('Tipo Sanguineo > ', TipoSanguineo),
    promptString('Plano de Saúde > ', PlanoSaude),
    promptString('Cardiopata (S ou N) > ', Cardiopata),
    promptString('Hipertenso (S ou N) > ', Hipertenso),
    promptString('Diabético (S ou N) > ', Diabetico),
    promptPassword('Senha > ', Senha),

    model:nextIdPaciente(N),
    assertz(model:paciente(N, Nome, CPF, Sexo, DataNascimento, Endereco, TipoSanguineo, PlanoSaude, Cardiopata, Hipertenso, Diabetico, Senha)),
    assertz(model:login_paciente(N, Senha)),
   
    persistence:saveIdPaciente,
    persistence:savePaciente,
    persistence:saveLoginPaciente,

    writeln('Paciente cadastrado com sucesso! Seu id é: ~d', [N]), sleep(1), loginPaciente.

loginPaciente :-
    tty_clear,
    utils:tituloInformacao('LOGIN PACIENTE'),
    prompt('ID > ', ID),
    promptPassword('Senha > ', Senha),
    utils:autenticaPaciente(ID, Senha, N),
    ( N =:= 1 -> tty_clear, menuPaciente(ID);
      writeln('Login ou senha inválidos'), utils:mensagemEspera, tty_clear, inicialPaciente).

menuPaciente(IdPac) :-
    tty_clear,
    utils:tituloInformacao('DASHBOARD PACIENTE'),
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