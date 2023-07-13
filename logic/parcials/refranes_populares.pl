% ================ Facts (knowledge db) ================
cuchillo(juan, palo).
cuchillo(pedro, palo).
cuchillo(ana, metal).
cuchillo(oscar, metal).

profesion(ana, costurera).
profesion(juan, herrero).
profesion(pedro, carpintero).
profesion(oscar, herrero).

anda(julia , daniel).
anda(julia , jorge).
anda(julia , raul).
anda(olga , jose).
anda(olga , claudio).
anda(olga , felipe).
anda(olga , carlos).
parece(daniel, buenaGente).
parece(jorge, buenaGente).
parece(raul, malandra).
parece(jose, ingeniero).
parece(claudio, periodista).
parece(felipe, ingeniero).
parece(carlos, contador).

%intenta(Persona, Tarea, Resultado, Fecha)
intenta(juan, paradigmas, 2, fecha(20,2,2004)).
intenta(juan, paradigmas, 2, fecha(20,2,2005)).
intenta(juan, paradigmas, 4, fecha(20,12,2005)).
intenta(pedro, romeoYJulieta, risas, fecha(20,2,2010)).
intenta(pedro, romeoYJulieta, llantos, fecha(20,2,2011)).
intenta(cachito, senador, [propuestas,honestidad,apoyoDeLosMedios, equipo, fortuna], fecha(27,10,2013)).

%exito(Tarea, Requisito).
exito(paradigmas, materia(4)).
exito(romeoYJulieta, teatro(drama,llantos)).
exito(laJaulaDeLasLocas, teatro(comedia, risas)).
exito(senador, politico([propuestas, honestidad, equipo])).
exito(diputado, politico([propuestas, apoyoDeLosMedios])).


% ================ Util predicates ================
incluido(X, Y) :-
    forall(member(Y1, Y), member(Y1, X)).

pasoPrimero(fecha(Dia1, Mes1, Ano1), fecha(Dia2, Mes2, Ano2)) :-
    Ano1 < Ano2.

pasoPrimero(fecha(Dia1, Mes1, Ano1), fecha(Dia2, Mes2, Ano2)) :-
    Ano1 = Ano2,
    Mes1 < Mes2.
    
pasoPrimero(fecha(Dia1, Mes1, Ano1), fecha(Dia2, Mes2, Ano2)) :-
    Ano1 = Ano2,
    Mes1 = Mes2,
    Dia1 < Dia2.

% ================ Queries ================
% A casa de herrero cuchillo de palo
esValidoParaUnHerrero(Herrero)  :-
    profesion(Herrero, herrero),
    cuchillo(Herrero, palo).

esValidoParaTodosLosHerreros() :-
    profesion(Herrero, _),
    forall(profesion(Herrero, herrero), esValidoParaUnHerrero(Herrero)).

esValidoParaLaMayoriaDeHerreros(HerrerosQueNoCumplen) :-
    findall(Herrero, (esValidoParaUnHerrero(Herrero)), HerrerosQueCumplen),
    findall(Herrero, (profesion(Herrero, herrero), not(esValidoParaUnHerrero(Herrero))), HerrerosQueNoCumplen),
    length(HerrerosQueCumplen, CantidadQueCumplen),
    length(HerrerosQueNoCumplen, CantidadQueNoCumplen),
    CantidadQueCumplen > CantidadQueNoCumplen.


% Dime quien eres y te dire con quien andas...
cuantosConQuienAndaTienenCaracterstica(Persona, Caracteristica, Cantidad) :-
    anda(Persona, _),
    parece(_, Caracteristica),
    findall(Anda, (anda(Persona, Anda), parece(Anda, Caracteristica)), Lista),
    length(Lista, Cantidad).

caracteristicaMasRepetida(Persona, Caracteristica1) :-
    anda(Persona, Anda),
    parece(Anda, Caracteristica1),
    cuantosConQuienAndaTienenCaracterstica(Persona, Caracteristica1, Cantidad1),
    not((cuantosConQuienAndaTienenCaracterstica(Persona, Caracteristica2, Cantidad2), Cantidad1 < Cantidad2, Caracteristica2 \= Caracteristica1)).
    

quienEres(Persona, Caracteristica) :-
    anda(Persona, _),
    caracteristicaMasRepetida(Persona, Caracteristica).


% La tercera es la vencida
esExitoso(Nota, materia(NotaEstipulada)) :-
    Nota >= NotaEstipulada.
esExitoso(Reaccion, teatro(Reaccion, _)).
esExitoso(Reaccion, teatro(_, Reaccion)).
esExitoso(Resultado, politico(ResultadoEsperado)) :-
    incluido(Resultado, ResultadoEsperado).

tuvoExito(Tarea, Resultado) :-
    exito(Tarea, ResultadoEsperado),
    esExitoso(Resultado, ResultadoEsperado).

esExitosoAlTercerIntento(Persona, Tarea) :-
    intenta(Persona, Tarea, _, Fecha1),
    intenta(Persona, Tarea, _, Fecha2),
    intenta(Persona, Tarea, Resultado, Fecha3),
    pasoPrimero(Fecha1, Fecha2),
    pasoPrimero(Fecha2, Fecha3),
    tuvoExito(Tarea, Resultado).

    