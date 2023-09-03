% ===================== Facts (knowledge db) =====================
% restaurante(Nombre, Estrellas, Barrio)
restaurante(panchoMayo, 2, barracas).
restaurante(finoli, 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).

% menu(Nombre, Detail)
% Detail: carta(Precio, Plato), pasos(NumeroDePasos, Precio, ListadeVinos, CantidadDeComenzales)
menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesa)).
menu(finoli, carta(2000, hamburguesa)).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama], 3)).

% vino(Nombre, PaisDeOrigen, CostoPerBotellas)
vino( chateauMessi, francia, 5000).
vino( francescoliSangiovese, italia, 1000).
vino( susanaBalboaMalbec, argentina, 1200).
vino( christineLagardeCabernet, argentina, 5200).
vino( guinoPin, argentina, 500).
vino( juanaDama, argentina, 1000).

paisImportador(argentina).
tasaAduanera(vinos, 35).

% ===================== Util Predicates =====================
promedio(Total, Cantidad, Promedio) :- 
    Promedio is Total / Cantidad.

porcentaje(Total, Porcentaje, Resultado) :-
    Resultado is Total + Total * Porcentaje / 100.

estrellasRestaurante(Restaurante, Estrellas) :-
    restaurante(Restaurante, Estrellas, _).

estrellasRestaurante(Restaurante, 0) :-
    menu(Restaurante, _),
    not(restaurante(Restaurante, _, _)).

% Utilizados para el query de los restaurantes mal organizados. Punto 3. 
menuOrganizado(Restaurante) :-
    menu(Restaurante, _),
    not((menu(Restaurante, carta(Precio1, Plato)), menu(Restaurante, carta(Precio2, Plato)), Precio1 \= Precio2)),
    forall((menu(Restaurante, pasos(NumeroDePasos, _, ListaDeVinos, _)), length(ListaDeVinos, CantidadDeVinos)), CantidadDeVinos >= NumeroDePasos).


tieneMasEstrellasQue(Restaurante1, Restaurante2) :-
    restaurante(Restaurante1, _, _),
    restaurante(Restaurante2, _, _),
    estrellasRestaurante(Restaurante1, Estrellas1),
    estrellasRestaurante(Restaurante2, Estrellas2),
    Estrellas1 > Estrellas2.

% Utilizados para el query de los restaurantes con copia barata. Punto 4
platoCartasIguales(Restaurante1, Restaurante2, Precio1, Precio2) :-
    menu(Restaurante1, carta(Precio1, Plato)), 
    menu(Restaurante2, carta(Precio2, Plato)).

esMasBarato(Precio1, Precio2) :-
    Precio1 < Precio2.

todosLosPlatosMasBaratos(Restaurante1, Restaurante2) :-
    forall(platoCartasIguales(Restaurante1, Restaurante2, Precio1, Precio2), esMasBarato(Precio1, Precio2)).

% Utilizados para el query del precio promedio por persona de un resturant. Punto 5
productoImportado(Pais) :-
    not(paisImportador(Pais)).

precioVino(Vino, PrecioFinal) :-
    vino(Vino, Pais, Precio),
    productoImportado(Pais),
    tasaAduanera(vinos, Tasa),
    porcentaje(Precio, Tasa, PrecioFinal).

precioVino(Vino, Precio) :-
    vino(Vino, Pais, Precio),
    not(productoImportado(Pais)).

sumaDePreciosVinos(ListaDeVinos, Suma) :-
    findall(PrecioFinal, (member(Vino, ListaDeVinos), precioVino(Vino, PrecioFinal)), ListaPrecioVinos),
    sumlist(ListaPrecioVinos, Suma).
    
precioMenuPorPersona(carta(Precio, _), Precio).
precioMenuPorPersona(pasos(_, Precio, ListaDeVinos, CantidadDeComenzales), PrecioPorPersona) :-
    sumaDePreciosVinos(ListaDeVinos, PrecioVinos),
    % No se chequea que CantidadDeComenzales sea distinto de 0 porque se asume, en el contexto, que es siempre > 0.
    PrecioPorPersona is (Precio + PrecioVinos) / CantidadDeComenzales.

precioDeTodosLosMenuesPorPersona(Restaurante, PrecioTotal) :-
    menu(Restaurante, _),
    findall(Precio, (menu(Restaurante, Menu), precioMenuPorPersona(Menu, Precio)), PreciosLista),
    sumlist(PreciosLista, PrecioTotal).

cantidadDeMenues(Restaurante, Cantidad) :-
    menu(Restaurante, _),
    findall(Menu, (menu(Restaurante, Menu)), MenuesLista),
    length(MenuesLista, Cantidad).

% ===================== Predicates (De los cuales se haran los queries) =====================
restaurantesConNMasEstrellas(Barrio, N, Restaurantes) :-
    restaurante(_, E, Barrio),
    between(1, E, N),
    findall(Restaurante, (restaurante(Restaurante, Estrellas, Barrio), Estrellas > N), Restaurantes).

restauranteSinEstrellas(Restaurante) :-
    menu(Restaurante, _),
    estrellasRestaurante(Restaurante, 0).

restauranteMalOrganizado(Restaurante) :-
    menu(Restaurante, _),
    not(menuOrganizado(Restaurante)).

restauranteEsCopiaBarata(Restaurante, CopiaBarata) :-
    menu(Restaurante, _),
    menu(CopiaBarata, _),
    tieneMasEstrellasQue(Restaurante, CopiaBarata),
    todosLosPlatosMasBaratos(CopiaBarata, Restaurante).

precioPromedioDeMenuesPerPersona(Restaurante, PrecioPromedio) :-
    menu(Restaurante, _),
    precioDeTodosLosMenuesPorPersona(Restaurante, PrecioTotal),
    % Se podria obtener la cantidad de menues desde el predicado de arriba. 
    % Si bien eso seria lo mas performant, seria menos legible y mas complejo de visualizar en el codigo. 
    % Y se prioriza la legibilidad ante la performance (en la mayoria de los casos).
    cantidadDeMenues(Restaurante, CantidadDeMenues),
    promedio(PrecioTotal, CantidadDeMenues, PrecioPromedio).
    

% =================== Punto 6 =========================
/**
 * Se podrian crear nuevos menus sin problemas en donde el campo Detail sea un dato distinto.
 * Esto es posible gracias a la idea de polimofirsmo en Prolog, ya que si bien es un lenguaje debilmente tipado, 
 * permite identificar datos mediante los functores. Asi, es posible crear predicados generalas que abarquen un 
 * abanico de soluciones particulares. Esto permite que el codigo sea muchisimo mas modular y resilente a los cambios.   
*/

% Por ejemplo: Si agregamos un menu nuevo tal que el campo Detail este compuesto por completo([detalle(Plato, Precio)]) 
% Lo unico que se tiene que hacer es agregar las nuevas soluciones particulares en los predicados generales que se definieron anteriormente
menu(panchoMayo, completo([detalle(suguchanJQ, 1500), detalle(arrozBlanco, 600), detalle(coquita, 400)])).

precioMenuPorPersona(completo(Platos), PrecioPorPersona) :-
    findall(Precio, (member(detalle(_, Precio), Platos)), PreciosLista),
    sumlist(PrecioLista, PrecioPorPersona).    

/**
 * Suguiendo la logica anterior, en cuanto a la consulta restauranteOrganizado, simplemente habria que agregar la sol particular
 * de menuOrganizado para el menu de tipo completo
*/

/**
 * Por otro lado, en cuanto a la consulta de los restaurantes copia barata, nada habria que hacer, ya que dicho predicado solo le interesan los menu del tipo carta.
 * En el caso de que le importen el menu agregado de tipo completo, entonces, nuevamente, bastaria con agregar la sol particular de menu completo al
 * predicado general platoCartasIguales. 
*/

% ===================== Tests (se corresponden al los ejemplos de consulta de la consigna) =====================
:- begin_tests(general).
    test(restaurantes_con_mas_de_2_estrellas) :-
       restaurantesConNMasEstrellas(villaCrespo, 2, [finoli, superFinoli]).

    test(restaurantes_sin_estrellas) :-
        restauranteSinEstrellas(noTanFinoli).

    test(restaurante_sin_estrellas, set(Restaurante == [finoli, panchoMayo, superFinoli])) :-
        restaurante(Restaurante, _, _),
        not(restauranteSinEstrellas(Restaurante)).

    test(restaurantes_mal_organizados) :-
        restauranteMalOrganizado(finoli).

    test(restaurantes_mal_organizados, set(Restaurante == [panchoMayo, noTanFinoli])) :-
        menu(Restaurante, _),
        not((restauranteMalOrganizado(Restaurante))).

    test(restaurantes_copias_baratas) :-
        restauranteEsCopiaBarata(finoli, panchoMayo).

    test(restaurantes_copias_baratas, set(Restaurante == [finoli, noTanFinoli, panchoMayo])) :-
        menu(Restaurante, _),
        not(restauranteEsCopiaBarata(panchoMayo, Restaurante)).

    test(restaurantes_precios_promedios) :-
        precioPromedioDeMenuesPerPersona(panchoMayo, 600).

    test(restaurantes_precios_promedios) :-
        precioPromedioDeMenuesPerPersona(finoli, 3025).

     test(restaurantes_precios_promedios) :-
        precioPromedioDeMenuesPerPersona(noTanFinoli, 1500).   
:- end_tests(general).