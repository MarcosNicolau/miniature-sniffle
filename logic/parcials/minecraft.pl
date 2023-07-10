% ================ Facts (knowledge db) ================
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

% ================ Utils predicates ================
tieneComestible(Jugador) :-
    comestible(Comestible),
    jugador(Jugador, Items, _),
    tieneItem(Jugador, Comestible).

estaEnLugar(Jugador, Lugar):-
    lugar(Lugar, Jugadores, _),
    member(Jugador, Jugadores).

% ================ Querys ================
tieneItem(Jugador, Item) :-
    jugador(Jugador, Items, _),
    member(Item, Items).

sePreocupaPorLaSalud(Jugador) :-
    jugador(Jugador, Items, _),
    comestible(Comestible1),
    comestible(Comestible2),
    member(Comestible1, Items),
    member(Comestible2, Items),
    Comestible1 \= Comestible2.

% the same but with findall, even though is discouraged by the exercise.
sePreocupaPorLaSalud(Jugador) :-
    jugador(Jugador, Items, _),
    findall(Comestible, (comestible(Item), member(Item, Items)), ItemsComestibles),
    length(ItemsComestibles, Length),
    Length >= 2.

cantidadQueTieneDeUnItem(Jugador, Item, Cantidad) :-
    distinct(tieneItem(_, Item)),
    jugador(Jugador, _, _),
    findall(Item, (jugador(Jugador, Items, _), member(Item, Items)), P),
    length(P, Cantidad).

tieneMasDe(Jugador1, Item) :- 
    jugador(Jugador1, _, _),
    tieneItem(_, Item),
    not((jugador(Jugador2, _, _), cantidadQueTieneDeUnItem(Jugador1, Item, Cantidad1),
    cantidadQueTieneDeUnItem(Jugador2, Item, Cantidad2), Cantidad2 > Cantidad1, Jugador1 \= Jugador2)).
   
hayMonstruos(Lugar) :-
    lugar(_, _, Oscuridad),
    Oscuridad > 6.

estaHambriento(Jugador) :-
    jugador(Jugador, _, Hambre),
    Hambre < 4.

estaEnLugarConMonstruos(Jugador) :-
    estaEnLugar(Jugador, Lugar),
    hayMonstruos(Lugar).

correPeligro(Jugador) :-
    estaEnLugarConMonstruos(Jugador).

correPeligro(Jugador) :-
    estaHambriento(Jugador),
    not(tieneComestible(Jugador)).


poblacion(Lugar, Poblacion) :-
    lugar(Lugar, Jugadores, _),
    length(Jugadores, Poblacion).

hambrientos(Jugadores, Cantidad) :-
    findall(Hambriento, (member(Hambriento, Jugadores), estaHambriento(Hambriento)), Hambrientos),
    length(Hambrientos, Cantidad).

nivelDePeligrosidad(Lugar, Peligrosidad) :-
    lugar(Lugar, Jugadores, _),
    not(hayMonstruos(Lugar)),
    poblacion(Lugar, Poblacion),
    Poblacion \= 0,
    hambrientos(Jugadores, CantHambrientos),
    Peligrosidad is CantHambrientos / Poblacion.

nivelDePeligrosidad(Lugar, Peligrosidad) :-
    lugar(Lugar, Jugadores, _),
    hayMonstruos(Lugar),
    Peligrosidad = 100.

nivelDePeligrosidad(Lugar, Peligrosidad) :-
    lugar(Lugar, _, Oscuridad),
    poblacion(Lugar, Poblacion),
    Poblacion = 0, 
    Peligrosidad is Oscuridad * 10.


puedeConstruirItem(Jugador, itemSimple(Item, CantidadNecesaria)) :-
    jugador(Jugador, Items, _),
    cantidadQueTieneDeUnItem(Jugador, Item, Cantidad),
    Cantidad >= CantidadNecesaria.

puedeConstruirItem(Jugador, itemCompuesto(Item)) :-
    puedeConstruirItem(Jugador, Item).


puedeConstruir(Jugador, Item) :-
    jugador(Jugador, Items, _),
    item(Item, Materiales),
    forall((member(Item, Materiales)), (puedeConstruirItem(Jugador, Item))).
