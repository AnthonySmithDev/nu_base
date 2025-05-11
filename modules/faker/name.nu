
def list_first [] {
  [ 'José' 'Luis' 'Carlos' 'Manuel' 'Juan' 'Jorge' 'Pedro' 'Roberto' 'Miguel' 'Fernando' 'Julio' 'Ricardo' 'Raúl' 'Alejandro' 'Mario' 'Marco' 'Antonio' 'Alfredo' 'Eduardo' 'Andrés' 'Sergio' 'Gustavo' 'César' 'Daniel' 'David' 'Gabriel' 'Victor' 'Pablo' 'Rodrigo' 'Leonardo' 'Franklin' 'Rolando' 'Alberto' 'Martín' 'Renzo' 'Jesús' 'Erick' 'Arturo' 'Omar' 'Ivan' 'Jaime' 'Franklin' 'Hugo' 'Armando' 'Guillermo' 'Enrique' 'Rodrigo' 'Fabián' ]
}

def list_last [] {
  [ 'Gonzales' 'Quispe' 'Huaman' 'Condori' 'Mamani' 'Paredes' 'Soto' 'Romero' 'Bautista' 'Pacheco' 'Vargas' 'Díaz' 'Ramos' 'Ruiz' 'Delgado' 'Fernández' 'Palomino' 'Roca' 'Peña' 'Rojas' 'Córdova' 'Tello' 'Mendoza' 'Paredes' 'Sánchez' 'López' 'Rodríguez' 'Vega' 'Torres' 'Castro' 'Huamaní' 'Flores' 'Nuñez' 'Luna' 'Quiñones' 'Silva' 'Valdivia' 'Valle' 'Benavides' 'Coronel' 'Leyva' 'Campos' 'Herrera' 'Escalante' 'Cáceres' 'Oliva' 'Gutiérrez' 'Guzmán' 'Aguirre' ]
}

export def first [] {
  let list = list_first
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

export def last [] {
  let list = list_last
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

export def full [] {
  return ((first) + " " + (last))
}
