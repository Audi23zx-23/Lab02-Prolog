power_list([
    power(logica, 100, 10),
    power(sigilo, 150, 30),
    power(fuerza, 250, 50)
]).

villain_list([
    villain(riddler, 90, [logica, sigilo]),
    villain(bane, 240, [fuerza])
]).

weakness_for(villain(_, _, Weakness), Power) :- member(Power, Weakness).

critictDamage(power(NamePower, BaseDamage,_), Villain, TotalDamage) :-
    (weakness_for(Villain, NamePower) ->  
    	TotalDamage is BaseDamage * 2 
    ;   
    	TotalDamage is BaseDamage
    ).

appliedpower(Power, villain(Name, Health, Weakness), Result) :-
    critictDamage(Power, villain(Name, Health, Weakness), Damage),
    NewHealth is Health - Damage,
    (NewHealth =< 0 -> Result = dead; Result = villain(Name, NewHealth, Weakness)).

remove_deceased([], []).
remove_deceased([deceased | Rest], AliveVillain) :-
    remove_deceased(Rest, AliveVillain).
remove_deceased([villain(N, H, W) | Rest], [villain(N, H, W) | AliveVillain]) :-
    remove_deceased(Rest, AliveVillain).

next_state(
    state(Villains, Powers, Energy),
    state(NewVillains, Powers, NewEnergy)
) :-
    member(Villain, Villains),          
    member(Power, Powers),             
    Power = power(_, _, Cost),
    Energy >= Cost,                     
    NewEnergy is Energy - Cost,        
    appliedpower(Power, Villain, AffectedVillain),
    select(Villain, Villains, RemainingVillains),
    (AffectedVillain = dead ->
        NewVillains = RemainingVillains; NewVillains = [AffectedVillain | RemainingVillains]
    ).

dfs(state([], _, _), _).              

dfs(State, Visited) :-
    next_state(State, NextState),
    \+ member(NextState, Visited),
    dfs(NextState, [NextState | Visited]).

batman_can_win(EnergiaMaxima) :-
    power_list(Powers),
    villain_list(Villains),
    EstadoInicial = state(Villains, Powers, EnergiaMaxima),
    dfs(EstadoInicial, [EstadoInicial]).
