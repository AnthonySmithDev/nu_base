
const items = [
    {name: "Laptop", desc: "Laptop ultradelgada con pantalla de 15 pulgadas", price: 1200},
    {name: "Smartphone", desc: "Teléfono inteligente con cámara de 48MP", price: 800},
    {name: "Tablet", desc: "Tablet con pantalla táctil de 10 pulgadas", price: 500},
    {name: "Smartwatch", desc: "Reloj inteligente con monitor de frecuencia cardíaca", price: 250},
    {name: "Auriculares", desc: "Auriculares inalámbricos con cancelación de ruido", price: 300},
    {name: "Teclado", desc: "Teclado mecánico retroiluminado", price: 100},
    {name: "Mouse", desc: "Mouse inalámbrico ergonómico", price: 50},
    {name: "Monitor", desc: "Monitor curvo de 27 pulgadas", price: 400},
    {name: "Impresora", desc: "Impresora multifunción a color", price: 200},
    {name: "Router", desc: "Router Wi-Fi de doble banda", price: 150},
    {name: "Cámara", desc: "Cámara réflex digital de 24MP", price: 900},
    {name: "Disco Duro", desc: "Disco duro externo de 1TB", price: 80},
    {name: "Memoria USB", desc: "Memoria USB de 64GB", price: 20},
    {name: "Altavoz", desc: "Altavoz Bluetooth portátil", price: 120},
    {name: "Proyector", desc: "Proyector HD de 1080p", price: 600},
    {name: "Batería Externa", desc: "Batería externa de 20000mAh", price: 40},
    {name: "Cargador", desc: "Cargador rápido de 30W", price: 25},
    {name: "Cable HDMI", desc: "Cable HDMI de alta velocidad", price: 15},
    {name: "Soporte para Laptop", desc: "Soporte ajustable para laptop", price: 30},
    {name: "Funda para Tablet", desc: "Funda protectora para tablet", price: 20}
]

export def main [] {
  let end = ($items | length) - 1
  let index = random int 0..$end
  return ($items | get $index)
}
