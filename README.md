# Projeto PLP - 2023.2
Repositório para o projeto da disciplina de PLP do curso CC@UFCG.

## EVERCARE
O sistema EverCare tem como objetivos o gerenciamento de clínicas médicas e otimizações na interação dos pacientes na busca e agendamento de consultas, além de outras utilidades. Seguem a seguir os usuários do sistema e as funcionalidades que o EverCare os possibilita

- Paciente:
    - Cadastrar-se e fazer login;
    - Marcar consultas
    - Confirmar ou Desmarcar Consultas
    - Ver Agendamentos
    - Feedback e Avaliação do médico que foi atendido
    - Busca por médicos ou clínica por nome específico
    - Buscar médicos por:
        - Plano de Saúde
        - Horários de atendimento
        - Agendamento ou Ordem de chegada
        - Avaliação de Médico
        - Especialidade
        - Sintomas
    - Ver receitas / laudos / solicitações de exames (Pós-Consulta)
    - Conversa com médico
    - Entra em fila virtual da consulta marcada por ordem de chegada

- Clínica:
    - Cadastrar-se e fazer login;
    - Histórico de pacientes, de médicos e de consultas marcadas (Ver se foram confirmadas)
    - Cadastra médicos com suas informações médicas
    - Dashboard:
        - Quantidade de Consultas, de Médicos e de Pacientes
        - Ranking de médicos (por avaliação / número de atendimentos)
    - Gerencia Fila Virtual:
        - Cria, Atualiza ou Deleta Filas

- Médico:
    - Fazer login
    - Disponibiliza:
        - receita
        - laudos 
        - solicitação de exames
    - Acessa dados dos pacientes agendados
    - Conversa com paciente

## Como rodar?
- Haskell:
Para rodar o sistema é necessário ter o `GHC` instalado na sua máquina, indicamos a instalação do [GHCup](https://www.haskell.org/ghcup/install/). 
É necessário apenas compilar e rodar o arquivo executável.
Abrindo do diretório raíz EverCare e rodar os comandos:
``` bash
ghc -o EverCare Haskell/App/Main.hs
./EverCare
```
- Prolog:
Abrindo do diretório Prolog/ basta rodar:
``` bash
swipl -q -1 -s view.pl -t begin
```
## Vídeo de Apresentação
Neste [vídeo](https://www.youtube.com/watch?v=7ZBJo5u_Q7Q), apresentamos todas as funcionalidades do nosso sistema.
