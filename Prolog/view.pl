:- encoding(utf8).

%
:- use_module('./App/utils.pl').
:- use_module('./Models/model.pl').
:- use_module('./Controllers/persistence.pl').
:- use_module('./Controllers/medicoController.pl').
:- use_module('./Controllers/pacienteController.pl').
:- use_module('./Controllers/clinicaController.pl').

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
      OP = "C" -> tty_clear, inicialClinica;
      OP = "M" -> tty_clear, inicialMedico;
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

    ( N > 0 -> format('Paciente cadastrado com sucesso! Seu id é: ~d~n', [N]), sleep(2), tty_clear, loginPaciente).

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

    ( OP = "B" -> tty_clear, buscarOpcoes(IdPac);
      OP = "M" -> tty_clear, cadastraConsulta(IdPac), !;
      OP = "V" -> tty_clear, verAgendamento(IdPac), utils:mensagemEspera, menuPaciente(IdPac);
      OP = "R" -> tty_clear, verPosConsulta(IdPac), utils:mensagemEspera, menuPaciente(IdPac);
      OP = "A" -> tty_clear, menuAvaliacao(IdPac), utils:mensagemEspera, tty_clear, menuPaciente(IdPac);
      OP = "C" -> tty_clear, menuChatPac(IdPac), tty_clear, menuPaciente(IdPac);
      OP = "F" -> tty_clear, menuFilaPac(IdPac),!;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuPaciente(IdPac)).

menuFilaPac(IdPac) :-
    tty_clear,
    utils:tituloInformacao('FILA VIRTUAL'),
    writeln('[E] - Entrar em Fila'),
    writeln('[V] - Ver Fila'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "E" -> tty_clear, entrarFila(IdPac), utils:mensagemEspera, tty_clear, menuPaciente(IdPac);
      OP = "V" -> tty_clear, verFilaPac(IdPac), utils:mensagemEspera, tty_clear, menuPaciente(IdPac);
      OP = "S" -> tty_clear, menuPaciente(IdPac);
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuFilaPac(IdPac)).

entrarFila(IdPac) :-
    tty_clear,
    utils:tituloInformacao('ENTRAR EM FILA'),
    prompt('ID Médico > ', IdMedico),
    (utils:validaIDMedico(IdMedico) ->
        (utils:validaPacienteMedico(IdPac, IdMedico) ->
            (utils:validaMedicoFila(IdMedico) ->
                retract(model:fila(IdFila, IdClinica, IdMedico, Fila)),
                utils:getPacienteID(IdPac, Nome),
                append(Fila, [Nome], FilaAtualizada),
                assertz(model:fila(IdFila, IdClinica, IdMedico, FilaAtualizada)),
                persistence:saveFila,
                persistence:saveIdFila,
                (IdFila > 0 -> 
                    writeln('Entrou na fila com sucesso!'),
                    format('O id da Fila é: ~d~n', [IdFila]),
                    length(FilaAtualizada, Tamanho),
                    format('Sua posição na fila é: ~d~n', [Tamanho]))
            ;
                writeln('Médico não possui fila')
            )
        ;
          writeln('Você não possui consultas com esse médico')
        )
    ;
      writeln('Médico não encontrado')
    ).

verFilaPac(IdPac) :- 
    tty_clear,
    utils:tituloInformacao('FILA VIRTUAL - PACIENTE'),
    prompt('ID Fila > ', IDFila),
        (utils:validaFilaPaciente(IdPac, IDFila) ->
            model:fila(IDFila, _, _, Fila),
            paciente:verFila(IDFila, IdPac, Posicao),
            (Fila \= [] ->
                format('Sua posição na fila é: ~d~n', [Posicao]))
        ;
            writeln('Você não está nessa fila')
        ).

menuAvaliacao(IdPac) :-
  tty_clear,
  utils:tituloInformacao('AVALIAR CONSULTA'),
  prompt('ID Médico > ', IdMedico),
  (utils:validaIDMedico(IdMedico) ->
    (
      prompt('Nota (Escala de 1 a 5) > ', Nota),
      (between(1, 5, Nota) -> % Verifica se a nota está entre 1 e 5
        promptString('Comentário > ', Comentario),
        assertz(model:avaliacao(IdPac, IdMedico, Nota, Comentario)),
        persistence:saveAvaliacao,
        medico:atualizarNota(IdMedico),
        writeln('Mensagem enviada e médico avaliado com sucesso!')
      ;
        writeln('Nota inválida. Por favor, insira uma nota entre 1 e 5.')
      )
    )
    ;
    writeln('Médico não encontrado'), !
  ).

menuChatPac(IdPac):-
    tty_clear,
    utils:tituloInformacao('CHAT'),
    writeln('[C] - Criar Chat com Médico'),
    writeln('[A] - Chats Ativos'),
    writeln('[M] - Enviar Mensagem em Chat Ativo'),
    writeln('[V] - Voltar'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, criarChatPac(IdPac), tty_clear, menuChatPac(IdPac);
      OP = "A" -> tty_clear, chatsAtivosPac(IdPac), utils:mensagemEspera, tty_clear, menuChatPac(IdPac);
      OP = "M" -> tty_clear, enviarMensagem(IdPac), tty_clear, menuChatPac(IdPac);
      OP = "V" -> tty_clear, menuPaciente(IdPac);
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuChatPac(IdPac)).

criarChatPac(IdPac):-
    tty_clear,
    utils:tituloInformacao('CRIAR CHAT'),
    prompt('ID Médico > ', IdMedico),
    (utils:validaIDMedico(IdMedico) -> 
      (utils:validaPacienteMedico(IdPac, IdMedico) -> 
        model:nextIdChat(IdChat),
        promptString('Mensagem > ', Mensagem),
        string_concat('P: ', Mensagem, MensagemP),
        assertz(model:chat(IdChat, IdPac, IdMedico, MensagemP)),

        persistence:saveChat,
        persistence:saveIdChat,
        (IdChat > 0 -> format('Chat criado com sucesso! O id do Chat é: ~d~n', [IdChat]), sleep(2), 
        utils:mensagemEspera, tty_clear, menuPaciente(IdPac))
        
        ;
        writeln('Você não possui consultas com esse médico.'), sleep(1), menuChatPac(IdPac)
      )
      ;
      writeln('Médico não encontrado'), sleep(1), menuChatPac(IdPac)
    ).

chatsAtivosPac(IdPac):- paciente:chatsAtivos(IdPac).

enviarMensagem(IdPac):-
    tty_clear,
    utils:tituloInformacao('ENVIAR MENSAGEM'),
    prompt('ID Chat > ', IdChat),
    (utils:validaIDChat(IdChat) -> 
      (utils:validaChatPaciente(IdPac, IdChat) ->

        promptString('Mensagem > ', MensagemAtual),
        string_concat('P: ', MensagemAtual, MensagemAtualP),

        retract(model:chat(IdChat, IdPaciente, IdMedico, Mensagem)),

        atomic_list_concat([Mensagem, MensagemAtualP], ' ', Mensagens),
        
        assertz(model:chat(IdChat, IdPaciente, IdMedico, Mensagens)),

        persistence:saveChat,
        writeln('Mensagem enviada com sucesso!'), sleep(1), utils:mensagemEspera, tty_clear, menuChatPac(IdPac)
      ;
        writeln('Você não possui chats com esse ID'), sleep(1), menuChatPac(IdPac)
      )
    ;
      writeln('Chat não encontrado'), sleep(1)
    ).

buscarOpcoes(IDPac):-
      tty_clear,
      utils:tituloInformacao('Menu Buscar'),
      write('[C] Buscar por Clínica'), nl,
      write('[M] Buscar por Médico'), nl,
      write('[E] Buscar por Especialidade'), nl,
      write('[P] Buscar Clínicas por Plano de Saúde'), nl,
      write('[A] Buscar Clínicas por Opção de Agendamento'), nl,
      write('[S] Buscar por Sintoma'), nl,
      write('[N] Buscar Médicos por Avaliação'), nl,
      write('[V] Voltar'), nl,
      promptOption('Opção > ', OP),
  
      ( OP = "C" -> tty_clear, menuBuscarClinica,utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "M" -> tty_clear, menuBuscarMedico,utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "E" -> tty_clear, menuBuscarEspecialidade,utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "P" -> tty_clear, menuBuscarClinicaPorPlano,utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "A" -> tty_clear, menuBuscarClinicaAgendamento, utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "S" -> tty_clear, menuBuscarPorSintoma, utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "N" -> tty_clear, menuMedicoAvaliacao, utils:mensagemEspera, tty_clear, buscarOpcoes(IDPac);
        OP = "V" -> tty_clear, menuPaciente(IDPac);
        writeln('Opção Inválida'), utils:mensagemEspera, buscarOpcoes(IDPac)).

menuMedicoAvaliacao:-
    tty_clear,
    utils:tituloInformacao('Buscar Médicos por Avaliação'),
    promptString('Nota acima de (1 a 5) > ', NotaStr),
    atom_number(NotaStr, Nota),
    (between(1, 5, Nota) -> 
        paciente:buscarMedicoAvaliacao(Nota),
    ;
        writeln('Nota inválida. Por favor, insira uma nota entre 1 e 5.'), utils:mensagemEspera, tty_clear, menuMedicoAvaliacao
    ).


menuBuscarPorSintoma:-
    tty_clear,
    utils:tituloInformacao('Buscar por Sintoma'),
    promptString('Sintoma > ', Sintoma),
    paciente:buscarPorSintoma(Sintoma).

menuBuscarEspecialidade:-
    tty_clear,
    utils:tituloInformacao('Buscar por Especialidade'),
    promptString('Especialidade > ', Especialidade),
    paciente:buscarEspecialidade(Especialidade).

menuBuscarClinica:-
    tty_clear,
    utils:tituloInformacao('Buscar Clínica'),
    promptString('Nome da Clínica > ', NomeClinica),
    paciente:buscarClinica(NomeClinica).

menuBuscarMedico:-
    tty_clear,
    utils:tituloInformacao('Buscar Médico'),
    promptString('Nome do Médico > ', Nome),
    paciente:buscarMedico(Nome).
   

menuBuscarClinicaPorPlano:-
    tty_clear,
    utils:tituloInformacao('Buscar Por Plano'),
    promptString('Digite o seu Plano > ', Planos),
    paciente:buscarClinicaPorPlano(Planos).

menuBuscarClinicaAgendamento :-
    tty_clear,
    utils:tituloInformacao('Informação sobre Agendamento'),
    promptString('Digite o método de agendamento (A)gendado ou (O)rdem de Chegada > ', Metodo),
    paciente:buscarClinicaAgendamento(Metodo).

verAgendamento(IdPac) :- 
  paciente:verConsultaP(IdPac),
  promptOption('Deseja (C)onfirmar ou (D)esmarcar uma Consulta? Ou (V)oltar > ', Op),
  ( Op = "C" -> confirmarConsulta(IdPac);
    Op = "D" -> desmarcarConsulta(IdPac);
    Op = "V" -> menuPaciente(IdPac);
    writeln('Opção Inválida')).

confirmarConsulta(IdPac) :-
    prompt('ID da Consulta > ', IdCons),
    (utils:validaIDConsulta(IdCons) ->
      (utils:validaConsultaPaciente(IdPac, IdCons) ->
        retract(model:consulta(IdCons, IdClinica, IdMedico, IdPac, DataConsulta, HoraConsulta, Queixas, _)),
        assertz(model:consulta(IdCons, IdClinica, IdMedico, IdPac, DataConsulta, HoraConsulta, Queixas, 'Confirmado')),
        persistence:saveConsulta,
        writeln('Consulta confirmada com sucesso!'), sleep(1), utils:mensagemEspera, tty_clear, menuPaciente(IdPac)
      ;
      writeln('Você não possui consultas com esse ID'), sleep(1), menuPaciente(IdPac)
      )
    ;
    writeln('Consulta não encontrada'), sleep(1)
    ).

desmarcarConsulta(IdPac) :-
    prompt('ID da Consulta > ', IdCons),
    (utils:validaIDConsulta(IdCons) ->
      (utils:validaConsultaPaciente(IdPac, IdCons) ->
        retract(model:consulta(IdCons, IdClinica, IdMedico, IdPac, DataConsulta, HoraConsulta, Queixas, C)),
        persistence:saveConsulta,
        writeln('Consulta desmarcada com sucesso!'), sleep(1), utils:mensagemEspera, tty_clear, menuPaciente(IdPac)
      ;
        writeln('Você não possui consultas com esse ID'), sleep(1), menuPaciente(IdPac)
      )
    ;
      writeln('Consulta não encontrada'), sleep(1)
    ).

verPosConsulta(IdPac) :-
    tty_clear,
    utils:tituloInformacao('RECEITAS / LAUDOS / SOLICITAÇÃO DE EXAMES'),
    writeln('[R] - Receitas'),
    writeln('[L] - Laudos'),
    writeln('[E] - Solicitação de Exames'),
    writeln('[V] - Voltar'),
    promptOption('Opção > ', OP),
    ( OP = "R" -> tty_clear, verReceita(IdPac);
      OP = "L" -> tty_clear, verLaudo(IdPac);
      OP = "E" -> tty_clear, verExame(IdPac);
      OP = "V" -> tty_clear, menuPaciente(IdPac);
      writeln('Opção Inválida')).

verReceita(IdPac) :- paciente:verReceita(IdPac).
verLaudo(IdPac) :- paciente:verLaudo(IdPac).
verExame(IdPac) :- paciente:verExame(IdPac).

inicialClinica :-
    tty_clear,
    utils:tituloInformacao('CLÍNICA'),
    writeln('[C] - Cadastrar'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, cadastraClinica;
      OP = "L" -> tty_clear, loginClinica;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialClinica).

cadastraClinica :-
    tty_clear,
    utils:tituloInformacao('CADASTRO DE CLÍNICA'),
    promptString('Nome > ', Nome),
    promptString('CNPJ > ', CNPJ),
    promptString('Endereço > ', Endereco),
    promptString('Planos de Saúde > ', Planos),
    promptString('Método de Agendamento (A)gendado ou (O)rdem de Chegada > ', MetodoAgendamento),
    promptString('Horário de Funcionamento > ', HorarioFuncionamento),
    promptString('Telefone > ', Telefone),
    promptString('Senha > ', Senha),

    model:nextIdClinica(N),
    assertz(model:clinica(N, Nome, CNPJ, Endereco, Planos, MetodoAgendamento, HorarioFuncionamento, Telefone, Senha)),
    assertz(model:login_clinica(N, Senha)),
   
    persistence:saveIdClinica,
    persistence:saveClinica,
    persistence:saveLoginClinica,

    ( N > 0 -> format('Clínica cadastrado com sucesso! Seu id é: ~d~n', [N]), sleep(2), tty_clear, loginClinica).

loginClinica :-
    tty_clear,
    utils:tituloInformacao('LOGIN CLÍNICA'),
    prompt('ID > ', ID),
    promptPassword('Senha > ', Senha),
    utils:autenticaClinica(ID, Senha, N),
    ( N =:= 1 -> tty_clear, menuClinica(ID);
      writeln('Login ou senha inválidos'), utils:mensagemEspera, tty_clear, inicialClinica).

menuClinica(IdClin) :-
    tty_clear,
    utils:tituloInformacao('MENU CLÍNICA'),
    write('-----------------------------'), nl,
    write('[C] Cadastrar Médico'), nl,
    write('[F] Fila Virtual'), nl,
    write('[V] Ver Informações'), nl,
    write('[D] Dashboard'), nl,
    write('[S] Sair'), nl,
    write('-----------------------------'), nl,
    promptOption('Opção > ', OP),

    ( OP = "C" -> tty_clear, cadastraMedico(IdClin), tty_clear, menuClinica(IdClin);
      OP = "F" -> tty_clear, filaVirtual(IdClin), !;
      OP = "V" -> tty_clear, visualizarInformacaoClinica(IdClin), utils:mensagemEspera, tty_clear, menuClinica(IdClin);
      OP = "D" -> tty_clear, verDashboard(IdClin), utils:mensagemEspera, tty_clear, menuClinica(IdClin);
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuClinica(IdClin)).

filaVirtual(IdClin) :-
    tty_clear,
    utils:tituloInformacao('FILA VIRTUAL - CLÍNICA'),
    writeln('[C] - Criar Fila'),
    writeln('[V] - Ver Fila'),
    writeln('[A] - Atualizar Fila'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, criarFila(IdClin), utils:mensagemEspera, tty_clear, menuClinica(IdClin);
      OP = "V" -> tty_clear, verFila(IdClin), utils:mensagemEspera, tty_clear, menuClinica(IdClin);
      OP = "A" -> tty_clear, atualizarFila(IdClin), utils:mensagemEspera, tty_clear, menuClinica(IdClin);
      OP = "S" -> tty_clear, menuClinica(IdClin), !;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, filaVirtual(IdClin)).

criarFila(IdClin) :-
    tty_clear,
    utils:tituloInformacao('CRIAR FILA'),
    prompt('ID Médico > ', IdMedico),
    (utils:validaIDMedico(IdMedico) ->
        (utils:validaMedicoClinica(IdClin, IdMedico) ->
            model:nextIdFila(IdFila),
            assertz(model:fila(IdFila, IdClin, IdMedico, [])),
            persistence:saveFila,
            persistence:saveIdFila,
            (IdFila > 0 -> format('Fila criada com sucesso! O id da Fila é: ~d~n', [IdFila]))
        ;
          writeln('Médico não é dessa clínica')
        )
    ;
      writeln('Médico não encontrado')
    ).

verFila(IdClin) :- clinica:verFila(IdClin).

atualizarFila(IdClin) :-
    tty_clear,
    utils:tituloInformacao('ATUALIZAR FILA'),
    prompt('ID Fila > ', IdFila),
    (utils:validaIDFila(IdFila) ->
        (utils:validaFilaClinica(IdFila, IdClin) ->
            model:fila(IdFila, IdClin, IdMedico, Fila),
            (Fila \= [] ->
                retract(model:fila(IdFila, IdClin, IdMedico, [Paciente|Resto])),
                assertz(model:fila(IdFila, IdClin, IdMedico, Resto)),
                persistence:saveFila,
                writeln('Paciente atendido com sucesso!')
            ;
                writeln('Fila vazia')
            )
        ;
            writeln('Fila não é dessa clínica')
        )
    ;
        writeln('Fila não encontrada')
    ).

verDashboard(IdClin) :-
    tty_clear,
    utils:tituloInformacao('DASHBOARD DA CLÍNICA'),
    clinica:getClinicaName(IdClin, NomeClinica),
    clinica:contarInformacoesClinica(IdClin, NumConsultas, NumMedicos, NumPacientes, RankingMedicos, PorNota),
    write('Nome da Clínica: '), write(NomeClinica), nl,
    write('Quantidade de Médicos: '), write(NumMedicos), nl,
    write('Quantidade de Consultas: '), write(NumConsultas), nl,
    write('Quantidade de Pacientes: '), write(NumPacientes), nl,
    write('---------------------------'), nl,
    write('RANKING MÉDICOS: '),nl,
    nl,
    write(' -POR N° DE CONSULTAS: '), nl, 
    nl, 
    call(clinica:showRankingMedicos(RankingMedicos)), nl,
    write(' -POR NOTA: '), nl,
    nl,
    call(clinica:showMedicosNota(PorNota)), nl,
    writeln('---------------------------').


visualizarInformacaoClinica(IdClin) :-
    tty_clear,
    utils:tituloInformacao('INFORMAÇÕES DA CLÍNICA'),
    write('-----------------------------'), nl,
    write('[A] - Agendamentos'), nl,
    write('[P] - Pacientes'), nl,
    write('[M] - Médicos'), nl,
    write('[V] - Voltar'), nl,
    write('-----------------------------'), nl,
    promptOption('Opção > ', OP),
    ( OP = "A" -> tty_clear, verConsultaClin(IdClin), !;
      OP = "P" -> tty_clear, verPacientes(IdClin), !;
      OP = "M" -> tty_clear, verMedicos(IdClin), !;
      OP = "V" -> tty_clear, menuClinica(IdClin);
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, visualizarInformacaoClinica(IdClin)).

verPacientes(IdClin) :- clinica:visualizaPacientes(IdClin).

verConsultaClin(IdClin) :- clinica:verAgendamentoClin(IdClin).

verMedicos(IdClin) :- clinica:verMedicos(IdClin).

cadastraMedico(IdClin) :-
    tty_clear,
    utils:tituloInformacao('CADASTRO DE MÉDICO'),
    promptString('Nome > ', Nome),
    promptString('CRM > ', CRM),
    promptString('Especialidade > ', Especialidade),
    promptString('Rede Social > ', RedeSocial),
    promptString('Senha > ', Senha),

    model:nextIdMedico(N),
    assertz(model:medico(IdClin, N, Nome, CRM, Especialidade, RedeSocial,'0.0', Senha)),
    assertz(model:login_medico(N, Senha)),
   
    persistence:saveIdMedico,
    persistence:saveMedico,
    persistence:saveLoginMedico,

    ( N > 0 -> format('Médico cadastrado com sucesso! Seu id é: ~d~n', [N]), sleep(2)).
  
inicialMedico :-
    tty_clear,
    utils:tituloInformacao('MÉDICO'),
    writeln('[L] - Login'),
    writeln('[S] - Sair'),
    promptOption('Opção > ', OP),
    ( OP = "L" -> tty_clear, loginMedico;
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, inicialMedico).

loginMedico :-
    tty_clear,
    utils:tituloInformacao('LOGIN MÉDICO'),
    prompt('ID > ', ID),
    promptPassword('Senha > ', Senha),
    utils:autenticaMedico(ID, Senha, N),
    ( N =:= 1 -> tty_clear, menuMedico(ID);
      writeln('Login ou senha inválidos'), utils:mensagemEspera, tty_clear, inicialMedico).


menuMedico(ID) :-
    tty_clear,
    utils:tituloInformacao('DASHBOARD MÉDICO'),
    write('[V] Ver Consultas'), nl,
    write('[E] Emitir Receita/Laudo'), nl,
    write('[C] Chats'), nl,
    write('[S] Sair'), nl,
    promptOption('Opção > ', OP),

    ( OP = "V" -> tty_clear, verConsultaMed(ID), utils:mensagemEspera, tty_clear, menuMedico(ID);
      OP = "E" -> tty_clear, menuMedicoEmitir(ID), utils:mensagemEspera, menuMedico(ID);
      OP = "C" -> tty_clear, menuChatMed(ID), tty_clear, menuMedico(ID);
      OP = "S" -> tty_clear, main;
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuMedico(ID)).

menuChatMed(IdMed):-
    tty_clear,
    utils:tituloInformacao('CHAT'),
    writeln('[C] - Criar Chat com Paciente'),
    writeln('[A] - Chats Ativos'),
    writeln('[M] - Enviar Mensagem em Chat Ativo'),
    writeln('[V] - Voltar'),
    promptOption('Opção > ', OP),
    ( OP = "C" -> tty_clear, criarChatMed(IdMed), tty_clear, menuChatMed(IdMed);
      OP = "A" -> tty_clear, chatsAtivosMed(IdMed), utils:mensagemEspera, tty_clear, menuChatMed(IdMed);
      OP = "M" -> tty_clear, enviarMensagemMed(IdMed), tty_clear, menuChatPac(IdMed);
      OP = "V" -> tty_clear, menuMedico(IdMed);
      writeln('Opção Inválida'), utils:mensagemEspera, tty_clear, menuChatMed(IdMed)).

criarChatMed(IdMed):-
    tty_clear,
    utils:tituloInformacao('CRIAR CHAT'),
    prompt('ID Paciente > ', IdPac),
    (utils:validaIDPaciente(IdPac) -> 
      (utils:validaPacienteMedico(IdPac, IdMed) ->
        model:nextIdChat(IdChat),
        promptString('Mensagem > ', Mensagem),
        string_concat('M: ', Mensagem, MensagemM),
        assertz(model:chat(IdChat, IdPac, IdMed, MensagemM)),

        persistence:saveChat,
        persistence:saveIdChat,

        (IdChat > 0 -> format('Chat criado com sucesso! O id do Chat é: ~d~n', [IdChat]), sleep(2), 
        utils:mensagemEspera, tty_clear, menuMedico(IdMed))
      ;
        writeln('Você não possui consultas com esse paciente.'), sleep(1), menuChatMed(IdMed)
      )
    ;
      writeln('Paciente não encontrado'), sleep(1), menuChatMed(IdMed)
    ).

chatsAtivosMed(IdMed):- medico:chatsAtivos(IdMed).

enviarMensagemMed(IdMed):-
    tty_clear,
    utils:tituloInformacao('ENVIAR MENSAGEM'),
    prompt('ID Chat > ', IdChat),
    (utils:validaIDChat(IdChat) -> 
      (utils:validaChatMedico(IdMed, IdChat) ->

        promptString('Mensagem > ', MensagemAtual),
        string_concat('M: ', MensagemAtual, MensagemAtualM),

        retract(model:chat(IdChat, IdPaciente, IdMed, Mensagem)),

        atomic_list_concat([Mensagem, MensagemAtualM], ' ', Mensagens),
        
        assertz(model:chat(IdChat, IdPaciente, IdMed, Mensagens)),

        persistence:saveChat,
        writeln('Mensagem enviada com sucesso!'), sleep(1), utils:mensagemEspera, tty_clear, menuChatMed(IdMed)
      ;
        writeln('Você não possui chats com esse ID'), sleep(1), menuChatMed(IdMed)
      )
    ;
      writeln('Chat não encontrado'), sleep(1)
    ).


verConsultaMed(IDM) :- medico:verConsultaM(IDM).

menuMedicoEmitir(IDM) :-
    tty_clear,
    utils:tituloInformacao('EMITIR'),
    write('[R] Receita'), nl,
    write('[L] Laudo'), nl,
    write('[E] Exame'), nl,
    write('[V] Voltar'), nl,
    promptOption('Opção > ', OP),

    ( OP = "R" -> tty_clear, emitirReceita(IDM), !;
      OP = "L" -> tty_clear, emitirLaudo(IDM), !;
      OP = "E" -> tty_clear, emitirExame(IDM), !;
      OP = "V" -> tty_clear, menuMedico(IDM);
      writeln('Opção Inválida')).

emitirReceita(IDM) :-
    tty_clear,
    utils:tituloInformacao('EMITIR RECEITA'),
    prompt('ID Paciente > ', IDP),
    (utils:validaIDPaciente(IDP) -> 
      (utils:validaPacienteMedico(IDP, IDM) ->

        promptString('Texto > ', Texto),
        assertz(model:receita(IDM, IDP, Texto)),
        persistence:saveReceita,
        writeln('Receita emitida com sucesso!'), sleep(1)
      ;
        writeln('Você não possui consultas com esse paciente.'), sleep(1)
      )
    ;
      writeln('Paciente não encontrado')
    ).

emitirLaudo(IDM) :-
    tty_clear,
    utils:tituloInformacao('EMITIR LAUDO'),
    prompt('ID Paciente > ', IDP),
    (utils:validaIDPaciente(IDP) ->
      (utils:validaPacienteMedico(IDP, IDM) ->
        promptString('Texto > ', Texto),
        assertz(model:laudo(IDM, IDP, Texto)),
        persistence:saveLaudo,
        writeln('Laudo emitido com sucesso!'), sleep(1)
      ;
        writeln('Você não possui consultas com esse paciente.'), sleep(1)
      )
    ;
      writeln('Paciente não encontrado')
    ).

emitirExame(IDM) :-
    tty_clear,
    utils:tituloInformacao('EMITIR EXAME'),
    prompt('ID Paciente > ', IDP),
    (utils:validaIDPaciente(IDP) ->
      (utils:validaPacienteMedico(IDP, IDM) ->
        promptString('Texto > ', Texto),
        assertz(model:exame(IDM, IDP, Texto)),
        persistence:saveExame,
        writeln('Exame emitido com sucesso!'), sleep(1)
      ;
        writeln('Você não possui consultas com esse paciente.'), sleep(1)
      )
    ;
      writeln('Paciente não encontrado')
    ).

cadastraConsulta(IdPac) :-
    tty_clear,
    utils:tituloInformacao('MARCAR CONSULTA'),
    prompt('ID Clínica > ', IdClinica),

    (utils:validaIDClinica(IdClinica) ->
        prompt('ID Médico > ', IdMedico),
        (utils:validaIDMedico(IdMedico) ->
            (utils:validaMedicoClinica(IdClinica, IdMedico) ->
                promptString('Data da Consulta (dd/mm/aaaa) > ', Data),
                (
                \+ dataValida(Data) ->
                    writeln('Data Inválida'),
                    utils:mensagemEspera,
                    tty_clear,
                    menuPaciente(IdPac)
                ;
                    utils:horariosDisponiveis(IdMedico, Data, Horarios),
                    writeln('Horários Disponíveis:'),
                    imprimirListaComEspacos(Horarios),
                    nl,
                    promptString('Horário da Consulta (hh:mm) > ', Horario),
                    
                    (\+ horaValida(Horario, Horarios) ->
                        writeln('Horário Inválido'),
                        utils:mensagemEspera,
                        tty_clear,
                        menuPaciente(IdPac)
                    ;
                        promptString('Queixa > ', Queixa),
                        model:nextIdConsulta(IdConsulta),
                        assertz(model:consulta(IdConsulta, IdClinica, IdMedico, IdPac, Data, Horario, Queixa, 'Pendente')),
                        persistence:saveIdConsulta,
                        persistence:saveConsulta,
                        format('Consulta marcada com sucesso! Seu ID de consulta é: ~d~n', [IdConsulta]),
                        utils:mensagemEspera,
                        tty_clear,
                        menuPaciente(IdPac)
                    )
                )
            ;
                writeln('Médico não pertence a clínica'),
                utils:mensagemEspera,
                tty_clear,
                menuPaciente(IdPac)
            )
        ;
            writeln('Médico não encontrado'),
            utils:mensagemEspera,
            tty_clear,
            menuPaciente(IdPac)
        )
            
      ;
        writeln('Clínica não encontrada'),
        utils:mensagemEspera,
        tty_clear,
        menuPaciente(IdPac)
    ).
