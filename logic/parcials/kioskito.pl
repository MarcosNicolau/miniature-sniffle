% ================ Facts (knowledge db) ================
% atiende(Nombre, Dia, HoraInicio, HoraFin)
atiende(dodain, horario(lunes, 9, 15)).
atiende(dodain, horario(miercoles, 9, 15)).
atiende(dodain, horario(viernes, 9, 15)).
atiende(lucas, horario(martes, 10, 20)).
atiende(juanC, horario(sabados, 18, 22)).
atiende(juanC, horario(domingos, 18, 22)).
atiende(juanFdS, horario(jueves, 10, 20)).
atiende(juanFdS, horario(viernes, 12, 20)).
atiende(leoC, horario(lunes, 14, 18)).
atiende(leoC, horario(miercoles, 14, 18)).
atiende(martu, horario(miercoles, 23, 24)).
atiende(vale, Horario) :-
    atiende(dodain, Horario).
atiende(vale, Horario) :-   
    atiende(juanC, Horario).
atiende(nadie, horario(_, Inicio, Fin)) :-
    atiende(leoC, horario(_, Inicio, Fin)).

atiende(malu, horario(martes, 24, 8)).
atiende(malu, horario(miercoles, 24, 8)).

% ================ Querys ================

% Parte 1 
quienAtiende(Persona, Dia, Hora) :-
    atiende(Persona, horario(Dia, HoraInicio, HoraFin)),
    between(HoraInicio, HoraFin, Hora).

% Parte 2 
atiendeSolo(Persona, Dia, Hora):-
    quienAtiende(Persona, Dia, Hora),
    not((quienAtiende(Persona2, Dia, Hora), Persona2 \= Persona1)).

% Parte 3 
combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas).

quienAtiendeEnElDia(Dia, Personas) :-
    findall(Persona, (distinct(Persona, quienAtiende(Persona, Dia, _))), ListaPosible),
    % backtracking algorithm prolog uses to get all of the posible solutions
    combinar(ListaPosible, Personas).


% Parte 4
% venta(Quien, Fecha, Producto)
venta(dodain, fecha(lunes, 10, agosto), [detalle(golosinas, 1200), detalle(cigarillos, [jockey])]).
venta(dodain, fecha(lunes, 10, agosto), [detalle(golosinas, 50), detalle(bebida, tipo(false, 1))]).


ventaImportante(detalle(golosinas, Precio)) :-
    Precio > 100.

ventaImportante(detalle(cigarillos, Marcas)) :-
    length(Marcas, Length),
    Length >= 2.

ventaImportante(detalle(bebida, tipo(true, _))).
ventaImportante(detalle(bebida, tipo(_, Cantidad))) :-
    Cantidad >=5.

vendedorSuertudo(Persona) :-
    venta(Persona, _, _),
    forall((venta(Persona, Fecha, [Venta|_])), ventaImportante(Venta)).


