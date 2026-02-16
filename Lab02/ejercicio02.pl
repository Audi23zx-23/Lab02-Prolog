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
    	%TotalDamage is BaseDamage * 2 
    ;   
    	TotalDamage is BaseDamage
    ).

appliedpower(power, villain(Name, Health, Weakness), Result) :-
    critictDamage(power, villain(Name, Health, Weakness), Damage),
    %NewHealth is Health - Damage,
    (NewHealt =< 0 ->  Result = muerto ; Result = villain(Name, NewHealth, Weakness)).

remove_deceased([], []).
remove_deceased([deceased | Rest], AliveVillain) :-
    remove_deceased(Rest, AliveVillain).
remove_deceased([villain(N, H, W) | Rest], [villain(N, H, W) | AliveVillain]) :-
    remove_deceased(Rest, AliveVillain).

next_state(
    state(Villain, Power, Energy),
    estado(NewVillains, Powers, NewEnergy)
) :-
    member(Villain, Villains),
    
    member(Power, Powers),
    Power = power(_, _, Cost),
    
    Energy >= Cost,
    
    appliedpower(Power, Villain, AffectVillain),
    
    select(Villain, Villains, RemainingVillains),
    (AffectVillain = dead ->
        NewVillains = RemainingVillains
    ;
        NewVillains = [AffectVillain| RemainingVillains]
    ).
    
    %NewEnergy is Energy - Cost

    
