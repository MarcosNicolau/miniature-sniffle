% ============= Facts (knowledge db) ==================
mesa( [carta(7,oro), carta(3, copa), carta(1,oro)]).
enMano( jugador1, [carta(sota, copa), carta(5, basto), carta(5, copa)]).
enMano( jugador2, [carta(rey, copa), carta(4, espada)]).
enMano( jugador3, [carta(2, copa), carta(3, espada)]).

valorCarta(carta(sota, _), 8).
valorCarta(carta(caballo, _), 9).
valorCarta(carta(rey, _), 10).
valorCarta(carta(Numero, _), Valor) :-
    number(Numero),
    between(1, 7, Numero),
    Valor is Numero.


% ============= Rules =============
sumarCartas(Cartas, Resultado) :-
    findall(Valor, (member(Carta,Cartas), valorCarta(Carta,Valor)), Puntos),
    sumlist(Puntos, Resultado).

suma15ConCartasMesa(Carta, CartasLevantadas) :-
    findall(Combinacion, (mesa(Mesa), append(Combinacion, _, Mesa), sumarCartas(Combinacion, Res), valorCarta(Carta, Valor), Res + Valor is 15), CartasLevantadasLista),
    CartasLevantadas = CartasLevantadasLista.
    

% ============= Querys =============
levantar(Jugador, Carta, CartasQueLevanta) :-
    enMano(Jugador, CartasJugador),
    member(Carta, CartasJugador),
    findall(CartasLevantadas, (enMano(Jugador, CartasJugador), member(Carta, CartasJugador), suma15ConCartasMesa(Carta, CartasLevantadas)), CartasQueLevantaLista),
    length(CartasQueLevantaLista, Length),
    Length > 1,
    max_member(CartasQueLevanta, CartasQueLevantaLista).
    
puedeHacerEscoba(Jugador, Carta) :-
    enMano(Jugador, CartasJugador),
    member(Carta, CartasJugador),
    suma15ConCartasMesa(Carta, CartasLevantadas),
    length(CartasMesa, CantidadCartasMesa),
    length(CartasLevantadas, CantidadDeCantasLevantadas),
    CantidadCartasMesa = CantidadDeCantasLevantadas.
