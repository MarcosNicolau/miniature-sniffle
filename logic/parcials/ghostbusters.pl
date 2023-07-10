% ================ Facts (knowledge db) ================
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

herramienta(egon, aspiradora(200)).
herramienta(egon, trapeador).
herramienta(peter, trapeador).
herramienta(winston, varitadeneutrones).

precio(ordenarCuarto, 500).
precio(limpiarTecho, 200).
precio(limpiarBanio, 1000).
precio(encerarPisos, 600).
precio(cortarPasto, 700).

tareaPedida(alberto, ordenarCuarto, 200).
tareaPedida(jorge, limpiarTecho, 50).
tareaPedida(daniel, bordedadora, 25).

tareaCompleja(limpiarTecho).

% ================ Util predicates ================
tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    length(HerramientasRequeridas, Length),
    Length > 2.

pedidosQueAcepta(ray, Tarea) :-
    Tarea \= limpiarTecho.

pedidosQueAcepta(winston, Tarea) :-
    cobro(Tarea, Total),
    Total > 500.

pedidosQueAcepta(peter, _).
pedidosQueAcepta(egon, Tarea) :-
    not(tareaCompleja(Tarea)).

% ================ Querys ================
poseeHerrammienta(HerramientaRequerida, Integrante) :-
    herramienta(Integrante, HerramientaRequerida).

poseeHerrammienta(aspiradora(PotenciaRequerida), Integrante) :-
    herramienta(Integrante, aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida).

puedeRealizarTarea(_, Integrante) :-
    herramienta(Integrante, varitadeneutrones).

puedeRealizarTarea(Tarea, Integrante) :-
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    herramienta(Integrante, _),
    forall(member(HerramientaRequerida, HerramientasRequeridas), poseeHerrammienta(HerramientaRequerida, Integrante)).

cobro(Cliente, Total) :-
    tareaPedida(Cliente, _, _),
    findall(Cobro, (tareaPedida(Cliente, Tarea, Metros), precio(Tarea, Precio), Cobro is Precio * Metros), Cobros),
    sumlist(Cobros, Total).

aceptariaPedido(Integrante, Cliente) :-
    tareaPedida(Cliente, Tarea, _),
    puedeRealizarTarea(Integrante, Tarea),
    pedidosQueAcepta(Integrante, Tarea).
