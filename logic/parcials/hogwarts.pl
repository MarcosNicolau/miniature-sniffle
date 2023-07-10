% ================ Facts (knowledge db) ================
% mago(Nombre, Caracteristicas, Sangre, Casa)
mago(harry, [corajudo, amistoso, orgulloso, inteligente], mestiza, slytherin).
mago(draco, [inteligente, orgulloso], pura, hufflepuff).
mago(hermione, [inteligente, orgulloso, responsable], impura, _).

sombrero(gryffindor, [corajudo]).
sombrero(slytherin, [orgulloso, inteligente]).
sombrero(ravenclaw, [inteligente, responsable]).
sombrero(hufflepuff, [amistoso]).



% ================ Rules ================

% == Parte 1 ==
casaPermiteMago(gryffindor, _).
casaPermiteMago(slitherin, mago(_, _, pura , _)).
casaPermiteMago(ravencalw, _).
casaPermiteMago(hufflepuff, _).
    
poseeCaracterParaCasa(Mago, Casa) :-
    mago(Mago, CaracteristicasMago, _, _),
    sombrero(Casa, CaracteristicasCasa),
    intersection(CaracteristicasCasa, CaracteristicasMago, CaracteristicasCasa).
    
casaQueLeToca(Mago, Casa) :-
    mago(Mago, _, _, CasaQueOdia),
    Casa \== CasaQueOdia,
    casaPermiteMago(Casa, Mago),
    poseeCaracterParaCasa(Mago, Casa).

casaQueLeToca(hermione, gryffindor).

cadenaDeAmistad([]).
cadenaDeAmistad([_]).
cadenaDeAmistad([Mago, MagoSig|Magos]) :-
    mago(Mago, Caracteristicas, _, _),
    member(amistoso, Caracteristicas),
    casaQueLeToca(Mago, Casa),
    casaQueLeToca(MagoSig, Casa),
    cadenaDeAmistad([MagoSig|Magos]).

% == Parte 2 ==
lugarProhibido(bosque, -50).
lugarProhibido(seccionRestringidaBiblioteca, -10).
lugarProhibido(tercerPiso, -75).

accion(harry, fueraDeLaCama).
accion(harry, irA(bosque)).
accion(harry, irA(seccionRestringidaBiblioteca)).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(seccionRestringidaBiblioteca)).
accion(draco, irA(mazmorras)).
accion(ron, buenaAccion(50, ganarAlAjedrezMagico)).
accion(hermione, buenaAccion(50, salvarASusAmigos)).
accion(harry, buenaAccion(60, ganarleAVoldemort)).

puntos(irA(Lugar), Puntos) :-
    lugarProhibido(Lugar, Puntos).
puntos(fueraDeLaCama, -50).
puntos(buenaAccion(Puntos, _), Puntos).
puntos(responderPregunta(_, Dificultad, snape), Puntos) :-
    Puntos is Dificultad / 2. 
puntos(responderPregunta(_, Dificultad, snape), Dificultad). 

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

esBuenAlumno(Mago) :-
    accion(Mago, _),
    forall((accion(Mago, Accion), puntos(Accion, Puntos)), Puntos > 0).

accionEsRecurrente(Accion) :-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \== Mago2.
    
puntajeCasa(Casa, Puntaje) :-
    esDe(_, Casa),
    findall(Puntos, (esDe(Mago, Casa), accion(Mago, Accion), puntos(Accion, Puntos)), PuntosLista),
    sumlist(PuntosLista, Puntaje).

casaGanadora(Casa) :-
    puntajeCasa(Casa,PuntajeMayor),
    forall((puntajeCasa(Casa2, PuntajeMenor), Casa \== Casa2), PuntajeMayor > PuntajeMenor).
    