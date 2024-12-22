import UIKit

struct Ejercicio {
    let dificultad: String
    let nombre: String
    let tiempo: String
    let imagen: String
    let boton: String
}

class EjercicioViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var ejercicioTableView: UITableView!

    var ejercicioList: [Ejercicio] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ejercicioTableView.dataSource = self // Delegado

        // Crear los ejercicios
        let ejercicio1 = Ejercicio(dificultad: "Medio", nombre: "Meditación", tiempo: "20 min", imagen: "meditación",boton: "Mas")
        let ejercicio2 = Ejercicio(dificultad: "Alto", nombre: "Caminar", tiempo: "30 min", imagen: "caminar",boton: "Mas")
        let ejercicio3 = Ejercicio(dificultad: "Bajo", nombre: "Yoga", tiempo: "10 min", imagen: "yoga",boton: "Mas")
        let ejercicio4 = Ejercicio(dificultad: "Alto", nombre: "Dibujar", tiempo: "40 min", imagen: "dibujar",boton: "Mas")

        // Agregar ejercicios a la lista
        ejercicioList.append(contentsOf: [ejercicio1, ejercicio2, ejercicio3, ejercicio4])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ejercicioList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ejercicioCell", for: indexPath) as! EjercicioTableViewCell
        let ejercicio = ejercicioList[indexPath.row]

        // Asignar valores a las etiquetas e imagen
        cell.dificultadLabel.text = ejercicio.dificultad
        cell.nombreLabel.text = ejercicio.nombre
        cell.tiempoLabel.text = ejercicio.tiempo
        cell.imageImageView.image = UIImage(named: ejercicio.imagen) // Asegúrate de que "imagen" tenga el nombre correcto


        // Cambiar el color de la etiqueta de dificultad
        switch ejercicio.dificultad {
        case "Bajo":
            cell.dificultadLabel.textColor = UIColor.green
        case "Medio":
            cell.dificultadLabel.textColor = UIColor.blue
        case "Alto":
            cell.dificultadLabel.textColor = UIColor.red
        default:
            cell.dificultadLabel.textColor = UIColor.black // Color por defecto si no coincide
        }

        return cell
    }
}
