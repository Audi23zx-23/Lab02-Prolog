ubicacion(orilla_inicial, 0, 5).
ubicacion(piedra1, 2, 4).
ubicacion(piedra2, 5, 6).
ubicacion(piedra3, 8, 4).
ubicacion(piedra4, 5, 0).
ubicacion(orilla_final, 10, 5).

salto_maximo(4.0).

distancia(X1, X2, Y1, Y2, Dist) :- 
    Dist is sqrt((X2 - X1)**2 + (Y2 - Y1)**2).

puede_saltar(Lugar1, Lugar2):-
    ubicacion(Lugar1, X1, Y1),
    ubicacion(Lugar2, X2, Y2),
    distancia(X1, X2, Y1, Y2, Dist),
    salto_maximo(Maximo),
    Dist =< Maximo.

siguiente_estado(pos(LugarActual), pos(LugarSiguiente)) :- puede_saltar(LugarActual, LugarSiguiente).

dfs(pos(orilla_final), Visitados, Solucion) :- reverse(Visitados, Solucion).

dfs(EstadoActual, Visitados, Solucion) :-
    siguiente_estado(EstadoActual, EstadoSiguiente),
    \+ member(EstadoSiguiente, Visitados), 
    dfs(EstadoSiguiente, [EstadoSiguiente | Visitados], Solucion).

buscar_solucion(Solucion) :-
    EstadoInicial = pos(orilla_inicial),
    dfs(EstadoInicial, [EstadoInicial], Solucion). 

        
