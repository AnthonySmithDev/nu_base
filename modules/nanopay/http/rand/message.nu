
const texts = [
    "Gracias por contactarnos. ¿En qué podemos ayudarte hoy?",
    "Hemos recibido tu solicitud de soporte. Nos pondremos en contacto contigo pronto.",
    "¿Podrías proporcionarnos más detalles sobre el problema que estás experimentando?",
    "Nuestro equipo está revisando tu caso. Te mantendremos informado.",
    "Gracias por tu paciencia mientras resolvemos este problema.",
    "Hemos identificado el problema y estamos trabajando en una solución.",
    "Por favor, verifica si el problema persiste después de reiniciar tu dispositivo.",
    "¿Has intentado actualizar la aplicación a la última versión?",
    "Te recomendamos revisar nuestra base de conocimientos para encontrar soluciones rápidas.",
    "Estamos aquí para ayudarte. ¿Necesitas asistencia adicional?",
    "Hemos enviado un correo electrónico con instrucciones para resolver el problema.",
    "Por favor, comparte una captura de pantalla del error que estás viendo.",
    "Nuestro equipo de soporte técnico está disponible las 24 horas del día.",
    "Gracias por reportar este problema. Estamos trabajando en una solución.",
    "¿Podrías confirmar si has recibido nuestro último correo electrónico?",
    "Hemos actualizado tu ticket de soporte con la información más reciente.",
    "Por favor, revisa tu bandeja de entrada y la carpeta de spam para nuestro correo.",
    "Estamos escalando tu caso a un especialista para una revisión más detallada.",
    "Gracias por tu colaboración. Esto nos ayuda a resolver el problema más rápido.",
    "Hemos solucionado el problema. Por favor, confírmanos si todo está en orden.",
    "¿Necesitas ayuda con la configuración de tu cuenta? Estamos aquí para ayudarte.",
    "Por favor, proporciona el número de serie de tu dispositivo para una mejor asistencia.",
    "Hemos detectado un problema conocido y estamos trabajando en una actualización.",
    "Gracias por tu retroalimentación. Nos ayuda a mejorar nuestros servicios.",
    "¿Podrías intentar desinstalar y reinstalar la aplicación para ver si eso resuelve el problema?",
    "Estamos realizando mantenimiento programado. Disculpa las molestias.",
    "Hemos resuelto el problema. Por favor, reinicia tu dispositivo para aplicar los cambios.",
    "¿Necesitas ayuda con la facturación? Estamos aquí para asistirte.",
    "Por favor, verifica tu conexión a internet y vuelve a intentarlo.",
    "Hemos recibido tu solicitud de reembolso. Estamos procesándola.",
    "Gracias por tu paciencia mientras investigamos este problema.",
    "¿Podrías proporcionar más detalles sobre el error que estás viendo?",
    "Hemos enviado un enlace para restablecer tu contraseña. Por favor, revisa tu correo.",
    "Estamos trabajando en una solución permanente para este problema.",
    "Gracias por reportar este error. Lo hemos añadido a nuestra lista de prioridades.",
    "¿Has intentado limpiar la caché de la aplicación para ver si eso ayuda?",
    "Hemos actualizado nuestra política de privacidad. Por favor, revísala.",
    "Estamos aquí para ayudarte con cualquier pregunta que tengas.",
    "Gracias por tu comprensión mientras resolvemos este problema.",
    "Hemos enviado un correo electrónico con instrucciones detalladas.",
    "Por favor, confirma si el problema persiste después de seguir nuestros pasos.",
    "Estamos realizando pruebas para asegurarnos de que el problema esté resuelto.",
    "Gracias por tu colaboración. Hemos registrado tu caso.",
    "¿Necesitas ayuda con la integración de nuestra API? Estamos aquí para ayudarte.",
    "Hemos detectado un problema con nuestro servidor. Estamos trabajando en ello.",
    "Por favor, revisa nuestra página de estado para obtener actualizaciones en tiempo real.",
    "Gracias por tu paciencia mientras resolvemos este problema técnico.",
    "Hemos solucionado el problema. Por favor, confírmanos si todo está bien.",
    "¿Podrías proporcionar el código de error que estás viendo?",
    "Estamos aquí para ayudarte con cualquier problema que tengas.",
    "Gracias por tu paciencia mientras investigamos este problema.",
    "Hemos enviado un correo electrónico con instrucciones para resolver el problema.",
    "Por favor, comparte una captura de pantalla del error que estás viendo.",
    "Nuestro equipo de soporte técnico está disponible las 24 horas del día.",
    "Gracias por reportar este problema. Estamos trabajando en una solución.",
    "¿Podrías confirmar si has recibido nuestro último correo electrónico?",
    "Hemos actualizado tu ticket de soporte con la información más reciente.",
    "Por favor, revisa tu bandeja de entrada y la carpeta de spam para nuestro correo.",
    "Estamos escalando tu caso a un especialista para una revisión más detallada.",
    "Gracias por tu colaboración. Esto nos ayuda a resolver el problema más rápido.",
    "Hemos solucionado el problema. Por favor, confírmanos si todo está en orden.",
    "¿Necesitas ayuda con la configuración de tu cuenta? Estamos aquí para ayudarte.",
    "Por favor, proporciona el número de serie de tu dispositivo para una mejor asistencia.",
    "Hemos detectado un problema conocido y estamos trabajando en una actualización.",
    "Gracias por tu retroalimentación. Nos ayuda a mejorar nuestros servicios.",
    "¿Podrías intentar desinstalar y reinstalar la aplicación para ver si eso resuelve el problema?",
    "Estamos realizando mantenimiento programado. Disculpa las molestias.",
    "Hemos resuelto el problema. Por favor, reinicia tu dispositivo para aplicar los cambios.",
    "¿Necesitas ayuda con la facturación? Estamos aquí para asistirte.",
    "Por favor, verifica tu conexión a internet y vuelve a intentarlo.",
    "Hemos recibido tu solicitud de reembolso. Estamos procesándola.",
    "Gracias por tu paciencia mientras investigamos este problema.",
    "¿Podrías proporcionar más detalles sobre el error que estás viendo?",
    "Hemos enviado un enlace para restablecer tu contraseña. Por favor, revisa tu correo.",
    "Estamos trabajando en una solución permanente para este problema.",
    "Gracias por reportar este error. Lo hemos añadido a nuestra lista de prioridades.",
    "¿Has intentado limpiar la caché de la aplicación para ver si eso ayuda?",
    "Hemos actualizado nuestra política de privacidad. Por favor, revísala.",
    "Estamos aquí para ayudarte con cualquier pregunta que tengas.",
    "Gracias por tu comprensión mientras resolvemos este problema.",
    "Hemos enviado un correo electrónico con instrucciones detalladas.",
    "Por favor, confirma si el problema persiste después de seguir nuestros pasos.",
    "Estamos realizando pruebas para asegurarnos de que el problema esté resuelto.",
    "Gracias por tu colaboración. Hemos registrado tu caso.",
    "¿Necesitas ayuda con la integración de nuestra API? Estamos aquí para ayudarte.",
    "Hemos detectado un problema con nuestro servidor. Estamos trabajando en ello.",
    "Por favor, revisa nuestra página de estado para obtener actualizaciones en tiempo real.",
    "Gracias por tu paciencia mientras resolvemos este problema técnico.",
    "Hemos solucionado el problema. Por favor, confírmanos si todo está bien.",
    "¿Podrías proporcionar el código de error que estás viendo?",
    "Estamos aquí para ayudarte con cualquier problema que tengas.",
    "Gracias por tu paciencia mientras investigamos este problema.",
    "Hemos enviado un correo electrónico con instrucciones para resolver el problema.",
    "Por favor, comparte una captura de pantalla del error que estás viendo.",
    "Nuestro equipo de soporte técnico está disponible las 24 horas del día.",
    "Gracias por reportar este problema. Estamos trabajando en una solución.",
    "¿Podrías confirmar si has recibido nuestro último correo electrónico?",
    "Hemos actualizado tu ticket de soporte con la información más reciente.",
    "Por favor, revisa tu bandeja de entrada y la carpeta de spam para nuestro correo.",
    "Estamos escalando tu caso a un especialista para una revisión más detallada.",
    "Gracias por tu colaboración. Esto nos ayuda a resolver el problema más rápido.",
    "Hemos solucionado el problema. Por favor, confírmanos si todo está en orden."
]

export def text [] {
  let end = ($texts | length) - 1
  let index = random int 0..$end
  return {
    msg_type: 1
    msg_data: ($texts | get $index)
  }
}

export def image [] {
  let seed = random chars --length 5
  return {
    msg_type: 2
    msg_data: $"https://picsum.photos/seed/($seed)/720/720"
  }
}

export def main [] {
  let n = (random int 1..10)
  match $n {
    1..2 => { image }
    _ => { text }
  }
}
