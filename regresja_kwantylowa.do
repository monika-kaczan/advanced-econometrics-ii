* 1. Wygenerować dummy variables dla zmiennych kategorycznych
* 2. Nie musimy podpisywać, jak będzie się nam generował wykres to tam będzie renovationCondition=cos
* 3. Spr. łączną istotność zmiennych kategorycznych

bsqreg ln_pricem2 aream2 kitchen bathroom renovationCondition2 renovationCondition3 renovationCondition4 buildingType2 buildingType3 buildingStructure2 buildingStructure3 buildingAge floor elevator fiveYearsProperty subway district2 district3 district4 district5 district6 district7 district8 district9 district10 district11 district12 district13, reps(9) 
grqreg, cons ols ci olsci reps(499)






* MNK *
regress ln_pricem2 aream2 kitchen bathroom i.renovationCondition i.buildingType i.buildingStructure buildingAge floor elevator fiveYearsProperty subway i.district month
estimates store MNK

* Regresja kwantylowa *
sqreg ln_pricem2 aream2 kitchen bathroom i.renovationCondition i.buildingType i.buildingStructure buildingAge floor elevator fiveYearsProperty subway i.district month, quantile(0.25) reps(999)
0.5 0.75) reps(999)



*Międzykwantylowe*
iqreg ln_pricem2 aream2 kitchen bathroom renovationCondition buildingType buildingStructure buildingAge floor elevator fiveYearsProperty subway district, quantile(0.25 0.5) reps(999)


*Wizualizacja*
bsqreg ln_pricem2 aream2 kitchen bathroom i.renovationCondition i.buildingType i.buildingStructure buildingAge floor elevator fiveYearsProperty subway i.district, reps(9) /* najpierw przypominamy zadeklarowanie regresji więc może być rep(9) */
grqreg, reps(499)


/*dodanie oszacowan MNK i przedzialow ufnosci*/
grqreg, cons ols ci olsci reps(499)

/*mozna tez prezentowac tylko dla wybranych zmiennych*/
grqreg plec, ols ci olsci reps(9) 
grqreg wiek wiek2, ols ci olsci reps(9)

*możemy musieć powtórzyć przypomnienienie zadeklarowanie regresji*
/*Zaprezentowanie wynikow (ktore wczesniej zapisalismy) w zwiezlej formie tabelarycznej*/
/*same oszacowania*/
estimates table MNK Q25 Q50 Q75

/*oszacowania + p-value*/
estimates table MNK Q25 Q50 Q75, p




sqreg ln_pricem2 aream2 kitchen bathroom renovationCondition2 renovationCondition3 renovationCondition4  i.buildingType i.buildingStructure buildingAge floor elevator fiveYearsProperty subway i.district month, quantile(0.25) reps(999)



* ================================================= *


/*Standardowa regresja + zapisanie wynikow*/
regress ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2
estimates store MNK


/*QREG - Standardowa regresja kwantylowa*/

/*Regresja kwantylowa dla mediany z domyslna macierza wariancji-kowariancji (skladnik losowy iid)*/
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2

/*ekwiwalentnie, ale explicite z podaniem konkretnego wariantu macierzy wariancji-kowariancji*/
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, vce(iid, fitted hsheather)

/*mozna zmieniac kazde ustawienie w vce(a, b c), ktora okresla macierz wariancji-kowariancji*/
/* a = {iid, robust} */
/* b = {fitted, residual, kernel[#nazwa]} (domyslnie kernel ep */
/* c = { hsheather, bofinger, chamberlain} */
/* Przyklady */
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, vce(iid, residual chamberlain)
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, vce(robust, kernel bofinger)

/*Regresja kwantylowa dla innych kwantyli*/
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.25)
qreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.75)


/*BSQREG - Regresja kwantylowa z bootstrapowana macierza wariancji-kowariancji - moim zdaniem zdecydowanie lepszy wybor niz QREG*/

bsqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, reps(99)
estimates store Q50
 
bsqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.25) reps(99)
estimates store Q25

bsqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.75) reps(99)
estimates store Q75


/*SQREG - Regresja kwantylowa z bootstrapowana macierza wariancji-kowariancji rownoczesnie dla wielu kwantyli - najwygodniejsza komenda w Stacie do regresji kwantylowej*/
sqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.25 0.75) reps(99)

/*po takiej regresji mozna przetestowac rownosc oszacowan parametrow dla roznych kwantyli - np*/ 
test [q25]plec=[q75]plec
test ([q25]plec=[q75]plec) ([q25]kawaler_panna=[q75]kawaler_panna)


/*IQREG - Regresja międzykwantylowa z bootstrapowana macierza wariancji-kowariancji - wygodniejsza metoda testowania roznic miedzy kwantylami*/
iqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, quantile(0.25 0.75) reps(99)


/*GRQREG - pakiet do prezentacja graficznej*/
/*najpierw instalacja*/
ssc install grqreg

/*a potem rysowanie wykresow z roznymi opcjami - komenda grqreg dziala po komendach qreg, bsqreg oraz sqreg*/
/*komenda grqreg wykorzystuje poprzednia regresje kwantylowa do zreplikowania listy zmiennych i przeprowadzenia obliczen od nowa*/ 
bsqreg ln_dochod plec kawaler_panna min_magister licencjat zawodowe max_gimnazjalne miasto_min500 miasto_200_500 wiek wiek2, reps(99)
grqreg, reps(9)
/*wartosc reps(#) powinna byc duzo wieksza (default=20), ale ta komenda jest dosc czasochlonna, wiec na potrzeby dydaktyczne zmniejszona*/

/*dodanie oszacowan MNK i przedzialow ufnosci*/
grqreg, cons ols ci olsci reps(9)

/*mozna tez prezentowac tylko dla wybranych zmiennych*/
grqreg plec, ols ci olsci reps(9)
grqreg wiek wiek2, ols ci olsci reps(9)


/*Zaprezentowanie wynikow (ktore wczesniej zapisalismy) w zwiezlej formie tabelarycznej*/
/*same oszacowania*/
estimates table MNK Q25 Q50 Q75

/*oszacowania + p-value*/
estimates table MNK Q25 Q50 Q75, p