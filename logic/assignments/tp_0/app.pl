nacio(nacho,bsas,26,6,1989).
nacio(tito,bsas,26,4,2000).
nacio(tita,bsas,23,3,2000).
nacio(lola,bsas,1,1,2001).


horoscopo_pdep(P, funcional) :-
    nacio(P, _, Dia, Mes, _),
    (
        (Mes = 3, Dia >= 23); 
        (Mes = 4);
        (Mes = 5, Dia =< 29)
    ).

horoscopo_pdep(P, logico) :-
    nacio(P, _, Dia, Mes, _),
    (
        (Mes = 5, Dia > 29);
        (Mes >= 6, Mes < 8);
        (Mes = 8, Dia =< 2)
    ).

horoscopo_pdep(P, oop) :-
    nacio(P, _, Dia, Mes, _),
    (
        (Mes = 8, Dia =< 2);
        (Mes > 8, Mes < 11);
        (Mes = 11, Dia =< 30)
    ).

horoscopo_pdep(P, sinSigno) :-
    nacio(P, _, Dia, Mes, _),
    \+ horoscopo_pdep(P, funcional),
    \+ horoscopo_pdep(P, logico),
    \+ horoscopo_pdep(P, oop).