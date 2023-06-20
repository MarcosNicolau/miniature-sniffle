# Consigna

## Ejemplos

### Uso de herramientas

-   Hacha:

```
hacha ártico
    "globo"
```

-   pala:

```
pala ártico
    "hielo"
```

### Que pasa ante la lista infinita de materiales?

Si al minar se le pasa una lista infinita de materiales, entonces en base a la herramienta indicada podrá corre o no, veamos: - hacha: En este caso NO se podría correr, ya que la lista es infinita y como tal no posee ultimo elemento - espada: En este casi SI podría correr, ya que no es necesario seguir evaluando/calculando la lista, simplemente toma el primer elemento y lo retorna. - caña: En este caso NO se podría correr, ya que hace uso de la length de la lista infinita, con lo cual se requiere el ultimo elemento que no exista porque nunca se termina de calcular - pico: En este caso SI podría correr, el razonamiento sigue el de la espada. En este caso, nuestro único limite seria el poder del procesador, ya que en el caso que se le pase un index muy grande, el calculo de la lista se vuelve muy demandante. - pala: En este caso se podría si y solo si se cumple el filter para un elemento

Ejemplos:
Supongamos que tenemos un bioma x que tiene una lista infinita de materiales = [m1, m2, m3, ...., mn]

-   Para la hacha:

```haskell
minar hacha personaje x
```

Nos debería devolver el mn elemento, pero n es infinito, por tanto al no converger no "existe"

-   Para la espada

```haskell
minar espada personaje x
```

Nos devuelve siempre m1, por tanto la función minar retorna el personaje con el inventario concatenado con m1

-   Para el pico

```haskell
minar (pico y) personaje x
```

Nos devuelve el elemento y de la lista materiales en tanto y en cuanto y no sea lo suficientemente grande como para agobiar al procesador y terminar el programa por falta de memoria.

## Responsables

Marcos Nicolau
