import Foundation

struct Elemento: Identifiable, Hashable {
    let id: String          // nombre EXACTO del objeto en Blender (dentro del panteón)
    let nombre: String      // título en pantalla
    let modelo: String      // archivo .usdz propio (opcional; se usa si la pieza no está en el panteón)
    let icono: String       // ícono temporal si no hay modelo
    let significado: String
}

// Los 5 elementos del panteón.
// Textos marcados como [PENDIENTE]: el equipo de contenido los investiga y completa.
let elementos: [Elemento] = [
    Elemento(id: "Iglesia", nombre: "Iglesia de San Andrés", modelo: "IglesiaMixquic",
             icono: "building.columns.fill",
             significado: "El panteón de Mixquic está dentro del atrio de la iglesia de San Andrés, algo poco común en la región."),
    Elemento(id: "Campana", nombre: "Campana", modelo: "Campana",
             icono: "bell.fill",
             significado: "[PENDIENTE] Qué papel tienen las campanas de la iglesia durante la Alumbrada."),
    Elemento(id: "Tumba", nombre: "Tumba iluminada", modelo: "Tumba",
             icono: "cross.fill",
             significado: "Las familias limpian y adornan las tumbas de sus difuntos, las iluminan con velas y las velan durante la noche."),
    Elemento(id: "Comida", nombre: "Comida", modelo: "Comida",
             icono: "fork.knife",
             significado: "Se ofrecen los platillos y bebidas que le gustaban al difunto."),
    Elemento(id: "Comal", nombre: "Comal", modelo: "Comal",
             icono: "frying.pan.fill",
             significado: "[PENDIENTE] Para qué se usa el comal en la celebración y qué se prepara en él.")
]
