nacio(nacho,bsas,26,6,1989).
nacio(tito,bsas,26,4,2000).
nacio(tita,bsas,23,3,2000).
nacio(lola,bsas,1,1,2001).

horoscopo_fecha(funcional, 23, 3, 29, 5).
horoscopo_fecha(logico, 30, 5, 1, 8).
horoscopo_fecha(oop, 2, 8, 30, 11).

happensAfter(D1, M, D2, M) :-
    D1 >= D2.
happensAfter(_, M1, _, M2) :-
    M1 > M2.

horoscopo(Persona, Tema) :-
    horoscopo_fecha(Tema, SD, SM, ED, EM),
    nacio(Persona, _, D, M, _),
    happensAfter(D, M, SD, SM),
    happensAfter(ED, EM, D, M).