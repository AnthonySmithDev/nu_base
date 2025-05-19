
const tickets = [
    {
        "title": "Problema con la transacción de Bitcoin",
        "desc": "No puedo completar mi transacción de Bitcoin. Me aparece un mensaje de error cada vez que intento enviar."
    },
    {
        "title": "Recuperación de contraseña de billetera",
        "desc": "Olvidé la contraseña de mi billetera de Ethereum. Necesito ayuda para recuperar el acceso."
    },
    {
        "title": "Depósito no reflejado en mi cuenta",
        "desc": "Hice un depósito de Litecoin hace 24 horas y aún no aparece en mi cuenta. ¿Qué debo hacer?"
    },
    {
        "title": "Error al retirar fondos",
        "desc": "Estoy intentando retirar mis fondos de Binance, pero el sistema me dice que hay un error en la transacción."
    },
    {
        "title": "Verificación de identidad pendiente",
        "desc": "He subido mis documentos para la verificación de identidad, pero aún no he recibido confirmación. ¿Cuánto tiempo tomará?"
    },
    {
        "title": "Problema con la sincronización de la billetera",
        "desc": "Mi billetera de Bitcoin no se sincroniza con la red. ¿Cómo puedo solucionar esto?"
    },
    {
        "title": "Transacción no confirmada",
        "desc": "Envié una transacción de Ethereum hace más de 12 horas y aún no ha sido confirmada. ¿Es normal?"
    },
    {
        "title": "Error en la API de trading",
        "desc": "Estoy usando la API de Coinbase para trading, pero no puedo ejecutar órdenes. ¿Qué está pasando?"
    },
    {
        "title": "Problema con la autenticación de dos factores",
        "desc": "Perdí mi dispositivo de autenticación de dos factores y no puedo acceder a mi cuenta. ¿Cómo puedo recuperarla?"
    },
    {
        "title": "Fondos desaparecidos",
        "desc": "Hice una transferencia de Ripple a otra billetera, pero los fondos no llegaron. ¿Dónde están?"
    },
    {
        "title": "Error en la conversión de monedas",
        "desc": "Intenté convertir Bitcoin a USDT, pero la transacción no se completó y no sé por qué."
    },
    {
        "title": "Problema con la integración de billetera",
        "desc": "Estoy intentando integrar mi billetera de MetaMask con un exchange, pero no funciona. ¿Qué debo hacer?"
    },
    {
        "title": "Error en la aplicación móvil",
        "desc": "La aplicación móvil de mi exchange se cierra cada vez que intento iniciar sesión. ¿Cómo lo soluciono?"
    },
    {
        "title": "Problema con la tarjeta de débito cripto",
        "desc": "Mi tarjeta de débito asociada a criptomonedas no funciona en los cajeros automáticos. ¿Qué está pasando?"
    },
    {
        "title": "Error en la compra de criptomonedas",
        "desc": "Intenté comprar Bitcoin con mi tarjeta de crédito, pero la transacción fue rechazada. ¿Por qué?"
    },
    {
        "title": "Problema con la API de precios",
        "desc": "La API de precios de criptomonedas que estoy usando no está actualizando los valores en tiempo real. ¿Cómo lo arreglo?"
    },
    {
        "title": "Error en la integración de hardware wallet",
        "desc": "No puedo conectar mi hardware wallet Ledger a la plataforma. ¿Qué debo hacer?"
    },
    {
        "title": "Problema con el staking de Ethereum",
        "desc": "He estado haciendo staking de Ethereum, pero no veo las recompensas en mi cuenta. ¿Es normal?"
    },
    {
        "title": "Error en la transacción de Binance Smart Chain",
        "desc": "Envié tokens BEP-20 a una dirección incorrecta. ¿Puedo recuperarlos?"
    },
    {
        "title": "Problema con la sincronización de nodos",
        "desc": "Mi nodo de Bitcoin no se sincroniza con la red. ¿Cómo puedo solucionar este problema?"
    }
]

export def main [] {
  let end = ($tickets | length) - 1
  let index = random int 0..$end
  return ($tickets | get $index)
}
