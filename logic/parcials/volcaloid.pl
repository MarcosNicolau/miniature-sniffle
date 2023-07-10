% ================ Facts (knowledge db) ================
cancion(nightFever, 4).
cancion(foreverYoung, 5).
cancion(tellYourWorld, 4).
cancion(tellYourWorld, 4).

cantante(megurineLuka, cancion(nightFever, 4)).
cantante(megurineLuka, cancion(foreverYoung, 5)).
cantante(hatsuneMiku, cancion(tellYourWorld, 4)).
cantante(gumi, cancion(tellYourWorld, 4)).
cantante(gumi, cancion(foreverYoung, 5)).
cantante(seeU, cancion(novemberRain, 6)).
cantante(seeU, cancion(nightFever, 5)).
cantante(kaito, nada).

concierto(mikuExpo, gigante(2, 6), estadosunidos, 2000).
concierto(magicMirai, gigante(3, 10), japon, 3000).
concierto(vocalektVisions, medio(9), estadosunidos, 1000).
concierto(mikuFest, pequeno(4), argentina, 100).

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, miki).
conoce(gumi, seeU).
conoce(seeU, kaito).

% ================ Util predicates ================
duracionCanciones(Cantante, Minutos) :-
    cantante(Cantante, _),
    findall(Minutos, (cantante(Cantante, cancion(_, Minutos))), MinutosLista),
    sum_list(MinutosLista, Minutos).

cancionesQueSabe(Cantante, Cantidad) :-
    cantante(Cantante, _),
    findall(Cancion, (cantante(Cantante, cancion(Cancion, _))), Canciones),
    length(Canciones, Cantidad).

sabeTantasCanciones(Cantante, Cantidad) :-
    cantante(Cantante, _),
    cancionesQueSabe(Cantante, Canciones),
    Canciones >= Cantidad. 

duraMasDe(Cantante, Duracion) :-
    cantante(Cantante, _),
    duracionCanciones(Cantante, Minutos),
    Minutos >= Duracion.

cumpleCondicionesConcierto(Cantante, gigante(CancionesQueTieneQueSaber, DuracionTotal)) :-
    cantante(Cantante, _),
    sabeTantasCanciones(Cantante, CancionesQueTieneQueSaber),
    duraMasDe(Cantante, DuracionTotal).

cumpleCondicionesConcierto(Cantante, medio(DuracionTotal)) :-
    cantante(Cantante, _),
    duraMasDe(Cantante, DuracionTotal).

cumpleCondicionesConcierto(Cantante, pequeno(DuracionDeUnaCancion)) :-
    cantante(Cantante, cancion(_, Duracion)),
    Duracion > DuracionDeUnaCancion.


% ================ Querys ================
cantanteNovedoso(Cantante) :-
    cantante(Cantante, _),
    sabeTantasCanciones(Cantante, 2),
    duracionCanciones(Cantante, 15).

cantanteAcelerado(Cantante) :-
    cantante(Cantante, _),
    not((cantante(Cantante, cancion(_, Minutos)), Minutos > 4)).
    
cantantePuedeParticiparEnConcierto(Cantante, Concierto) :-
    cantante(Cantante, _),
    concierto(Concierto, Tamano, _, _),
    cumpleCondicionesConcierto(Cantante, Tamano).
    
cantantePuedeParticiparEnConcierto(hatsuneMiku, _).

puntosDeFama(Cantante, Puntaje) :-
    cantante(Cantante, _),
    findall(Puntos, (cantantePuedeParticiparEnConcierto(Cantante, Concierto), concierto(Concierto, _, _, Puntos)), PuntosLista),
    sum_list(PuntosLista, SumaPuntos),
    cancionesQueSabe(Cantante, CancionesQueSabe),
    Puntaje is CancionesQueSabe * SumaPuntos. 

esMasFamoso(Cantante1, Cantante2) :-
    puntosDeFama(Cantante1, PuntosMayor), 
    puntosDeFama(Cantante2, PuntosMenor), 
    Cantante1 \== Cantante2, 
    PuntosMayor < PuntosMenor.

cantanteMasFamoso(Cantante) :-
    cantante(Cantante, _),
    puntosDeFama(Cantante, PuntosMayor),
    not((esMasFamoso(_, Cantante))).

conocido(Cantante, Conocido) :-
    conoce(Cantante, Conocido).

conocido(Cantante, Conocido) :-
    conoce(Cantante, UnCantante),
    conoce(UnCantante, Conocido).

esElUnicoQueParticipa(Cantante) :-
    cantante(Cantante, _),
    cantantePuedeParticiparEnConcierto(Cantante, Concierto),
    not((conocido(Cantante, Conocido), cantantePuedeParticiparEnConcierto(Conocido, Concierto))).