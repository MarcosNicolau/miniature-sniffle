# Impuesto automotor 

**Dado un conjunto de personas con sus respecivos autos, queremos averiguar cuántos millonarios honestos hay.**

Tenemos información sobre los autos:

```Haskell
data Auto = UnAuto {
    marca::String,
    modelo:: Int,
    kilometraje:: Float } deriving (Show, Eq)
```

Algunos ejemplos de autos
```Haskell
ferrari,fitito, reno :: Auto
ferrari = UnAuto "ferrari" 1990 100
fitito = UnAuto "fiat" 1960 1000000
reno = UnAuto "renault" 2023 0
```

* Se debe agregar información sobre las personas, asumiendo que de cada una sabemos su nombre, si paga sus impuestos y el conjunto de autos que tiene registrados a su nombre.
* Se considera millonario a una persona si la sumatoria del valor de sus autos es mayor a 1000000
* Se considera honesto a quien paga sus impuestos
* El valor de un auto se calcula con una extraña fórmula en la que interviene el kilometraje y modelo del año, con un incremento si se trata de una marca importada. (Inventarla!!)
* Se sabe cuáles son las marcas importadas.
