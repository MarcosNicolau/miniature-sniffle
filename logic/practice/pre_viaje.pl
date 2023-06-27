% ============= Facts (knowledge db) ==================
placeBusiness(iguazu, grandHotelIguazu).
placeBusiness(iguazu, gargantaDelDiabloTour).
placeBusiness(bariloche, aerolineas).

% invoice(Person, InvoiceDetail).
invoice(estanislao, hotel(grandHotelIguazu, 2000)).
invoice(antonietaPerez, excursion(gargantaDelDiabloTour, 5000, 4)).
invoice(antonietaPerez, vuelo(1515, antonietaPerez)).


maxHotelPrice(5000).
maxReturnMoney(10000).


%flightRegister(FlightNumber, Place, Business, Passeners, Price)
flightRegister(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).


% =================== Rules ========================
    
% --- Utils ---
percentage(Value, Percentage, Result) :-
    Result is (Value * Percentage) / 100.

hasCommmerce(Commerce) :-
    placeBusiness(_, Commerce).

numberOfCitiesTraveled(Person, Result) :- 
    invoice(Person, _),
    findall(City, (flightRegister(Number, City, _, People, _), member(Person, People), isValidInvoice(vuelo(Number, Person))), Cities),
    length(Cities, Result).

hasInvalidInvoice(Person) :-
    invoice(Person, Action),
    not(isValidInvoice(Action)).

%isValidInvoice(InvoiceDetail)
isValidInvoice(hotel(Commerce, Price)) :-
    hasCommmerce(Commerce),
    maxHotelPrice(Q),
    Price =< Q.
    
isValidInvoice(excursion(Commerce, _, _)) :-
    hasCommmerce(Commerce).

isValidInvoice(vuelo(Number, FlightName)) :-
    invoice(FlightName, vuelo(Number, FlightName)).

% returnInvoiceMoney(InvoiceDetail, MoneyReturned)
returnInvoiceMoney(hotel(Commerce, Price), MoneyReturned) :-
    isValidInvoice(hotel(Commerce, Price)),
    percentage(Price, 50, MoneyReturned).

returnInvoiceMoney(vuelo(Number, FlightName), MoneyReturned):-
    isValidInvoice(vuelo(Number, FlightName)),
    flightRegister(Number, Place, _, _, Price),
    Place \= buenosaires,
    percentage(Price, 30, MoneyReturned).

returnInvoiceMoney(excursion(Commerce, Payment, People), MoneyReturned) :-
    isValidInvoice(excursion(Commerce, _, _)),
    Percentage is 80 / People,
    percentage(Payment, Percentage, MoneyReturned).

% returnMoneyExtras(Person, MoneyReturned)
returnMoneyExtras(Person, MoneyReturned) :-
    hasInvalidInvoice(Person),
    MoneyReturned is -15000.

returnMoneyExtras(Person, MoneyReturned) :-
    numberOfCitiesTraveled(Person, Number),
    MoneyReturned is Number * 1000.

% --- Utils ---
suprassReturnLimit(Amount, Limit) :-
    maxReturnMoney(Limit),
    Amount > Limit.

returnMoneySum(Person, Sum) :-
    invoice(Person, _),
    findall(Money, (invoice(Person, Action), returnInvoiceMoney(Action, Money)), MoneyList),
    findall(Money, (returnMoneyExtras(Person, Money)), ExtraMoneyList),
    append(MoneyList, ExtraMoneyList, Concatenation),
    sumlist(Concatenation, Sum).

% --- Queries ---
returnMoneyPerson(Person, MoneyReturned) :-
    returnMoneySum(Person, Sum),
    suprassReturnLimit(Sum, Limit),
    MoneyReturned = Limit.

returnMoneyPerson(Person, MoneyReturned) :-
    returnMoneySum(Person, Sum),
    not(suprassReturnLimit(Sum, _)),
    MoneyReturned is Sum.

placeForWork(Place) :-
    placeBusiness(Place, _),
    findall(Place, (invoice(_, hotel(Name, _)), placeBusiness(Place, Name)), PlaceList),
    length(PlaceList, Length),
    Length = 1.

placeForWork(Place) :-
    flightRegister(_, Place, _, _ , _),
    placeBusiness(Place, Name),
    not(invoice(_, hotel(Name, _))).

areYouAHustler(Person) :-
    invoice(Person, _),
    forall(invoice(Person, Action), not(isValidInvoice(Action))).