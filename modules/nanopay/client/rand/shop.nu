
const shops = [
  { name: "TechWorld", desc: "Tienda especializada en dispositivos electrónicos de última generación." },
  { name: "GadgetGalaxy", desc: "Ofrece una amplia gama de gadgets y accesorios tecnológicos." },
  { name: "ElectroHub", desc: "Centro de venta de electrodomésticos y dispositivos inteligentes." },
  { name: "SmartTech", desc: "Tienda líder en tecnología inteligente y soluciones IoT." },
  { name: "FutureGadgets", desc: "Innovación en tecnología con los gadgets más avanzados." },
  { name: "TechNest", desc: "Tu hogar para todo lo relacionado con la tecnología y electrónica." },
  { name: "DigitalBazaar", desc: "Mercado digital con las mejores ofertas en tecnología." },
  { name: "InnovateTech", desc: "Especialistas en tecnología innovadora y soluciones empresariales." },
  { name: "GizmoCentral", desc: "El lugar perfecto para encontrar los mejores gizmos y dispositivos." },
  { name: "TechTrends", desc: "Sigue las últimas tendencias en tecnología con nosotros." },
  { name: "ElectroZone", desc: "Zona de electrónica con productos de alta calidad y precios competitivos." },
  { name: "NextGenTech", desc: "Explora la próxima generación de tecnología y dispositivos." },
  { name: "TechHaven", desc: "Refugio para los amantes de la tecnología y los gadgets." },
  { name: "GadgetHive", desc: "Colmena de gadgets y dispositivos tecnológicos innovadores." },
  { name: "TechPulse", desc: "El latido de la tecnología con los productos más recientes." },
  { name: "DigitalEdge", desc: "Lleva tu experiencia digital al límite con nuestros productos." },
  { name: "TechOasis", desc: "Un oasis de tecnología en medio del desierto digital." },
  { name: "GadgetForge", desc: "Forjamos los mejores gadgets para tus necesidades tecnológicas." },
  { name: "TechVortex", desc: "Sumérgete en el vórtice de la tecnología con nuestros productos." },
  { name: "ElectroSphere", desc: "Esfera de electrónica con productos de vanguardia." }
]

export def main [] {
  let end = ($shops | length) - 1
  let index = random int 0..$end
  return ($shops | get $index)
}
