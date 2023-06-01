import Text.Show.Functions ()

-- ====== Types declaration ======
type Juez = Ley -> Bool  
data Ley = UnaLey
  { nombreLey :: String,
    tema :: String,
    presupuesto :: Float,
    gruposColaboradores :: [String]
  }
  deriving (Show, Eq)


-- ====== Definición de datos ======
-- Agenda
temasAgenda :: [String]
temasAgenda = ["Educación", "Salud"]

-- Leyes
cannabisMedicinal, educaciónSuperior, profesionalizaciónTenistaDeMesa, tenis :: Ley
cannabisMedicinal = UnaLey "Ley de uso medicinal del cannabis" "Salud" 5 ["Cambio de todos", "Sector Financiero"]
educaciónSuperior = UnaLey "Ley de educación superior" "Educación" 30 ["Docentes Universitarios", "Centro Federal", "Cambio de todos"]
profesionalizaciónTenistaDeMesa = UnaLey "Ley de profesionalización del tenista de mesa" "Deporte" 1 ["Centro Federal", "Liga de deportistas autónomos", "Club paleta veloz"]
tenis = UnaLey "Ley para que se juegue al tenis en todos los colegios del país" "Deporte" 2 ["Liga de deportistas autónomos", "Club paleta veloz"]

leyes :: [Ley]
leyes = [cannabisMedicinal, educaciónSuperior, profesionalizaciónTenistaDeMesa, tenis]

-- Jueces
john, paul, martin, george, ringo, roger, david, sid :: Juez
john ley = tema ley `elem` temasAgenda
paul ley = "Sector Financiero" `elem` gruposColaboradores ley
martin ley = presupuesto ley <= 10
george ley = presupuesto ley <= 20
ringo ley = "Partido Conservador" `elem` gruposColaboradores ley
roger ley = True
david ley = tema ley == "Deportes"
sid ley = presupuesto ley <= 5

-- Corte
corteActual :: [Juez]
corteActual = [john, paul, martin, george, ringo, roger, david, sid]

-- ====== Util fns ======
compartenAlgúnElem :: (Eq a) => [a] -> [a] -> Bool
compartenAlgúnElem lista1 lista2 = any (`elem` lista2) lista1

-- ====== Compatibilidad de leyes ======
sectorEnComún :: Ley -> Ley -> Bool
sectorEnComún ley1 ley2 = compartenAlgúnElem (gruposColaboradores ley1) (gruposColaboradores ley2)

temasCompatibles :: Ley -> Ley -> Bool
temasCompatibles ley1 ley2 = tema ley1 == tema ley2

leyesSonCompatibles :: Ley -> Ley -> Bool
leyesSonCompatibles ley1 ley2 = sectorEnComún ley1 ley2 && temasCompatibles ley1 ley2

-- ====== Constitucionalidad de leyes ======
vota::Ley->Juez->Bool
vota ley juez = juez ley
votosAFavor :: Ley -> [Juez] -> Int
votosAFavor ley corte = length (filter (vota ley) corte)

constitucionalidad :: Ley -> [Juez] -> Bool
constitucionalidad ley corte = fromIntegral (votosAFavor ley corte) >= (fromIntegral (length corte) / 2)

constitucionalidadSiSeAgreganJueces :: [Ley] -> [Juez] -> [Juez] -> [Ley]
constitucionalidadSiSeAgreganJueces leyesATratar corte juecesAAgregar = filter (`constitucionalidad` (corte ++ juecesAAgregar)) (filter (\ley -> not (constitucionalidad ley corte)) leyesATratar)

-- ====== Principios ======
borocotizar :: [Juez] -> [Juez]
borocotizar = map (not .) 

coincideConSectorSocial :: Juez -> String -> [Ley] -> Bool
coincideConSectorSocial juez sectorSocial leyesATratar = all (\ley -> sectorSocial `elem` gruposColaboradores ley) (filter juez leyesATratar)