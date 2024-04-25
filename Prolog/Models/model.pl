:- module(model, [iniciaPaciente/0, iniciaClinica/0, iniciaMedico/0, iniciaConsulta/0,
                  iniciaInicioConsulta/0, iniciaFimConsulta/0, iniciaMHorarios/0,
                  iniciaLaudo/0, iniciaExame/0, iniciaReceita/0, iniciaChat/0,
                  iniciaFila/0, iniciaAvaliacao/0, iniciaLogins/0, iniciaId/0,
                  nextId/1]).

:- use_module('../Persistence/persistence.pro').

/*
 Inicializa a tabela dinâmica de pacientes.
 Campos esperados: ID, Nome, CPF, Data de Nascimento, Sexo, Endereço, Plano de Saúde,
 Tipo Sanguíneo, Cardiopata (booleano), Diabético (booleano), Hipertenso (booleano), Senha.
*/
iniciaPaciente :- dynamic paciente/12.

/*
 Inicializa a tabela dinâmica de clínicas.
 Campos esperados: ID, Nome, Endereço, Planos de Saúde Aceitos, Método de Agendamento, Contato, Senha.
*/
iniciaClinica :- dynamic clinica/7.

/*
 Inicializa a tabela dinâmica de médicos.
 Campos esperados: ID da Clínica, ID, Nome, CRM, Especialidade, Senha, Nota (avaliação).
*/
iniciaMedico :- dynamic medico/7.

/*
 Inicializa a tabela dinâmica de consultas.
 Campos esperados: ID da Consulta, ID do Paciente, ID da Clínica, ID do Médico, 
 Data da Consulta, Horário, Queixas, Confirmado (booleano).
*/
iniciaConsulta :- dynamic consulta/8.

/*
 Inicializa a tabela dinâmica para o horário de início das consultas.
 Campos esperados: ID da Consulta, Horário de Início (como time(H, M)), Dia da Semana (1 a 6).
*/
iniciaInicioConsulta :- dynamic m_inicio/3.

/*
 Inicializa a tabela dinâmica para o horário de fim das consultas.
 Campos esperados: ID da Consulta, Horário de Fim (como time(H, M)), Dia da Semana (1 a 7).
*/
iniciaFimConsulta :- dynamic m_fim/3.

/*
 Inicializa a tabela dinâmica para horários gerais das consultas.
 Campos esperados: ID da Consulta, Horário (como date(Y, M, D, H, MN, S, Off, -, -)).
 Utilizado para guardar detalhes específicos dos horários das consultas, incluindo data e fuso horário.
*/
iniciaMHorarios :- dynamic m_horarios/2.

/*
 Inicializa a tabela dinâmica de laudos.
 Campos esperados: ID do Laudo, ID do Médico, ID do Paciente, Texto do Laudo.
*/
iniciaLaudo :- dynamic laudo/4.

/*
 Inicializa a tabela dinâmica de exames.
 Campos esperados: ID do Exame, ID do Paciente, ID do Médico, Tipo de Exame.
*/
iniciaExame :- dynamic exame/4.

/*
 Inicializa a tabela dinâmica de receitas.
 Campos esperados: ID da Receita, ID do Médico, ID do Paciente, Texto da Receita.
*/
iniciaReceita :- dynamic receita/4.

/*
 Inicializa a tabela dinâmica de Chats.
 Campos esperados: ID, ID do Paciente, ID do Médico, Mensagens.
*/
iniciaChat :- dynamic chat/4.

/*
 Inicializa a tabela dinâmica de filas.
 Campos esperados: ID, ID da Clínica, ID do Médico, Fila.
*/
iniciaFila :- dynamic fila/4.

/*
 Inicializa a tabela dinâmica de avaliações.
 Campos esperados: ID da Avaliação, ID do Paciente, ID do Médico, Nota, Comentário.
*/
iniciaAvaliacao :- dynamic avaliacao/5.

/*
 Inicializa a tabela dinâmica de logins.
 Campos esperados: ID, Senha, Tipo de Usuário.
 Tipo de usuário: 0 - Paciente, 1 - Clínica, 2 - Médico.
*/
iniciaLogins :- dynamic logins/3.

/*
 Inicializa os ids do sistema, começando do 0.
*/
iniciaId :- asserta(id(0)).

/*
 Pega o próximo ID do sistema.
*/
nextId(N) :- id(X), retract(id(X)), N is X + 1, asserta(id(N)).

/*
Verifica se o arquivo 'consulta.bd' existe, se existir o lê,
c.c. chama model:iniciaConsulta.
*/
leConsulta :- consult('bd/consulta.bd').

/*
Verifica se o arquivo 'medico.bd' existe, se existir o lê,
c.c. chama model:iniciaMedico.
*/
leMedico :- consult('bd/medico.bd').

/*
Verifica se o arquivo 'clinica.bd' existe, se existir o lê,
c.c. chama model:iniciaClinica.
*/
leClinica :- consult('bd/clinica.bd').

/*
Verifica se o arquivo 'inicio_consulta.bd' existe, se existir o lê,
c.c. chama model:iniciaInicioConsulta.
*/
leInicioConsulta :- consult('bd/inicio_consulta.bd').

/*
Verifica se o arquivo 'fim_consulta.bd' existe, se existir o lê,
c.c. chama model:iniciaFimConsulta.
*/
leFimConsulta :- consult('bd/fim_consulta.bd').

/*
Verifica se o arquivo 'm_horarios.bd' existe, se existir o lê,
c.c. chama model:iniciaMHorarios.
*/
leMHorarios :- consult('bd/m_horarios.bd').

/*
Verifica se o arquivo 'receita.bd' existe, se existir o lê,
c.c. chama model:iniciaReceita.
*/
leReceita :- consult('bd/receita.bd').

/*
Verifica se o arquivo 'laudo.bd' existe, se existir o lê,
c.c. chama model:iniciaLaudo.
*/
leLaudo :- consult('bd/laudo.bd').

/*
Verifica se o arquivo 'exame.bd' existe, se existir o lê,
c.c. chama model:iniciaExame.
*/
leExame :- consult('bd/exame.bd').

/*
Verifica se o arquivo 'avaliacao.bd' existe, se existir o lê,
c.c. chama model:iniciaAvaliacao.
*/
leAvaliacao :- consult('bd/avaliacao.bd').

/*
Verifica se o arquivo 'fila.bd' existe, se existir o lê,
c.c. chama model:iniciaFila.
*/
leFila :- consult('bd/fila.bd').

/*
Verifica se o arquivo 'chat.bd' existe, se existir o lê,
c.c. chama model:iniciaChat.
*/
leChat :- consult('bd/chat.bd').

/*
Verifica se o arquivo 'logins.bd' existe, se existir o lê,
c.c. chama model:iniciaLogins.
*/
leLogins :- consult('bd/logins.bd').

/*
Verifica se o arquivo 'id.bd' existe, se existir o lê,
c.c. chama model:iniciaId.
*/
leId :- consult('bd/id.bd').


/*
Inicializa todas as tabelas do sistema de uma só vez.
*/
iniciaSistema :- 
    verificaPaciente, verificaConsulta, verificaMedico, verificaClinica, 
    verificaInicioConsulta, verificaFimConsulta, verificaMHorarios,
    verificaReceita, verificaLaudo, verificaExame, verificaAvaliacao, 
    verificaFila, verificaChat, verificaLogins, verificaId.

verificaPaciente :- exists_file('bd/paciente.bd') -> lePaciente ; iniciaPaciente.

verificaConsulta :- exists_file('bd/consulta.bd') -> leConsulta ; iniciaConsulta.

verificaMedico :- exists_file('bd/medico.bd') -> leMedico ; iniciaMedico.

verificaClinica :- exists_file('bd/clinica.bd') -> leClinica ; iniciaClinica.

verificaInicioConsulta :- exists_file('bd/inicio_consulta.bd') -> leInicioConsulta ; iniciaInicioConsulta.

verificaFimConsulta :- exists_file('bd/fim_consulta.bd') -> leFimConsulta ; iniciaFimConsulta.

verificaMHorarios :- exists_file('bd/m_horarios.bd') -> leMHorarios ; iniciaMHorarios.

verificaReceita :- exists_file('bd/receita.bd') -> leReceita ; iniciaReceita.

verificaLaudo :- exists_file('bd/laudo.bd') -> leLaudo ; iniciaLaudo.

verificaExame :- exists_file('bd/exame.bd') -> leExame ; iniciaExame.

verificaAvaliacao :- exists_file('bd/avaliacao.bd') -> leAvaliacao ; iniciaAvaliacao.

verificaFila :- exists_file('bd/fila.bd') -> leFila ; iniciaFila.

verificaChat :- exists_file('bd/chat.bd') -> leChat ; iniciaChat.

verificaLogins :- exists_file('bd/logins.bd') -> leLogins ; iniciaLogins.

verificaId :- exists_file('bd/id.bd') -> leId ; iniciaId.





