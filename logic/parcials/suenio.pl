% ================ Facts (knowledge db) ================
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

suenio(gabriel, ganarLoteria([5, 9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).
suenio(macarena, cantante(10000)).

equipoChico(arsenal).
equipoChico(aldosivi).

amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

enfermo(campanita).
enfermo(conejoDePascua).
enfermo(reyesMagos).

% ================ Util predicates ================
dificultadSuenio(ganarLoteria(Numero), Dificultad) :-
    length(Numero, CantNumeros),
    Dificultad is CantNumeros * 10.
dificultadSuenio(futbolista(Equipo), 3) :-
    equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo), 16) :-
    not(equipoChico(Equipo)).
dificultadSuenio(cantante(VentaDiscos), 6) :-
    VentaDiscos > 500000.
dificultadSuenio(cantante(VentaDiscos), 4) :-
    VentaDiscos < 500000.

sumaDificultadSuenios(Persona, Suma) :-
    suenio(Persona, _),
    findall(Dificultad, (suenio(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), DificultadLista),
    sumlist(DificultadLista, Suma).

esSuenioPuro(cantante(VentaDiscos)) :-
    VentaDiscos < 200000.
esSuenioPuro(futbolista(_)).
    
personajeBackUp(Personaje, BackUp) :-
    amigo(Personaje, BackUp).

personajeBackUp(Personaje, BackUp) :-
    amigo(Personaje, Personaje2),
    amigo(Personaje2, BackUp).

% ================ Querys  ================
esAmbiciosa(Persona) :-
    suenio(Persona, _),
    sumaDificultadSuenios(Persona, Suma),
    Suma > 20.

tienenQuimica(Persona, Personaje) :-
    cree(Persona, Personaje),
    Personaje \= campanita,
    not(esAmbiciosa(Persona)),
    forall(suenio(Persona, Suenio), esSuenioPuro(Suenio)).

tienenQuimica(Persona, campanita) :-
    cree(Persona, campanita),
    suenio(Persona, Suenio),
    dificultadSuenio(Suenio, Dificultad),
    Dificultad < 5.

puedeAlegrarAUnaPersona(Personaje, Persona) :-
    suenio(Persona, _),
    tienenQuimica(Persona, Personaje),
    not(enfermo(Personaje)).

puedeAlegrarAUnaPersona(Personaje, Persona) :-
    suenio(Persona, _),
    tienenQuimica(Persona, Personaje),
    personajeBackUp(Personaje, Conocido),
    not(enfermo(Conocido)).



% :- begin_tests(general).

% test(tienen_quimica, set(Persona == [gabriel, juan, macarena], )) :-
%     tienenQuimica(Persona, Personaje).

% :- end_tests(general).
