# :- module (paciente, [consultarReceitas/1]).

# :- use_module('../App/show.pl').
# :- use_module('../Models/model.pl').
# :- use_module('../App/utils.pl').

# /*
#     Consulta as receitas de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarReceitas(IDPac) :- forall(model:receita(Id, IdMed, IdPac, texto), show:showReceita(model:receita(Id, IdMed, IdPac, texto))).

# /*
#     Consulta os medicamentos de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarLaudo(IDPac) :- forall(model:laudo(Id, IdMed, IdPac, texto), show:showLaudo(model:laudo(Id, IdMed, IdPac, texto))).

# /*
#     Consulta os exames de um paciente.
#     @param IDPac ID do paciente.
# */
# consultarExames(IDPac) :- forall(model:exame(Id, IdMed, IdPac, tipo), show:showExame(model:exame(Id, IdMed, IdPac, tipo))).
