:- encoding(utf8).

%
:- use_module('./Utils/utils.pro').
:- use_module('./Utils/time.pro').
:- use_module('./Models/model.pro').
:- use_module('./Controllers/pacienteController.pro').
:- use_module('./Controllers/medicoController.pro').
:- use_module('./Controllers/ubsController.pro').
:- use_module('./Persistence/persistence.pro').

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
      OP = "C" -> tty_clear, inicialClinica;
      OP = "M" -> tty_clear, inicialMedico;
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
      OP = "L" -> tty_clear, login;
      OP = "S" -> writeln('Saindo...');
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialPaciente).

/* Menu de login do médico. */
inicialMedico :-
    tituloI('MÉDICO', Titulo),
    writeln(Titulo),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "L" -> tty_clear, loginMedico;
      OP = "S" -> writeln('Saindo...');
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialMedico).

/* Menu de login da clínica. */
inicialClinica :-
    tituloI('CLÍNICA', Titulo),
    writeln(Titulo),
    writeln('[C] - Cadastrar'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, cadastraClinica, tty_clear, inicialClinica;
      OP = "L" -> tty_clear, loginClinica;
      OP = "S" -> writeln('Saindo...');
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialClinica).

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
    
    model:criaPaciente(Nome, CPF, Sexo, DataNascimento, Endereco, Telefone, PlanoSaude, Cardiopata, Hipertenso, Diabetico, Senha),
    writeln('Paciente cadastrado com sucesso!').
