
def list_city [] {
  [ 'Lima' 'Arequipa' 'Trujillo' 'Chiclayo' 'Piura' 'Iquitos' 'Cuzco' 'Huancayo' 'Chimbote' 'Pucallpa' 'Tacna' 'Juliaca' 'Ayacucho' 'Huaraz' 'Sullana' 'Cajamarca' 'Puno' 'Chincha' 'Huánuco' 'Ica' 'Tumbes' 'Tarapoto' 'Jaén' 'Andahuaylas' 'Moquegua' 'Huarmey' 'Huacho' 'Puerto Maldonado' 'Abancay' 'Huaral' ]
}

export def city [] {
  let list = list_city
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

def list_address [] {
  [ 'Calle los Olivos 345, Miraflores, Lima' 'Av. Los Pumas 877, Trujillo' 'Jirón Los Rosales 434, San Isidro, Lima' 'Pasaje San Martín 120, Cusco' 'Jr. Las Margaritas 654, Surquillo, Lima' 'Plaza De Armas 321, Arequipa' 'Calle El Sol 456, Juliaca' 'Calle Real 775, Huancayo' 'Av. Tacna 34, Puno' 'Pasaje Las Lomas 109, Chiclayo' 'Av. Los Conquistadores 893, San Isidro, Lima' 'Av. El Sol 265, Cusco' 'Jr. Bolognesi 47, Tacna' 'Av. Mariscal Castilla 765, Iquitos' 'Calle Libertad 198, Piura' 'Pasaje Los Pinos 321, San Miguel, Lima' 'Av. Amazonas 678, Tumbes' 'Calle Progreso 894, Huaraz' 'Jirón Arica 12, Moquegua' 'Av. Santa Rosa 456, Callao, Lima' 'Street Los Cedros 678, Chachapoyas' 'Pasaje Los Eucalyptus 900, Barranco, Lima' 'Jirón San Ignacio 123, Ayacucho' 'Calle Las Orquídeas 567, Cajamarca' 'Av. Los Álamos 872, Chincha.' ]
}

export def address [] {
  let list = list_address
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

def list_code [] {
  [ '15001' '07001' '04001' '08001' '20001' '14001' '13001' '23001' '12001' '21001'  '06001' '05001' '16001' '02001' '11001' '22001' '25001' '09001' '01001' '24001' ]
}

export def code [] {
  let list = list_code
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}
