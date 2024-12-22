import UIKit
import CoreData
import PhotosUI

class DiarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    @IBOutlet weak var diarioTableView: UITableView!

    var diarioList: [DiarioEntity] = []
    var imagenesSeleccionadas: [UIImage] = []  // Para almacenar las imágenes seleccionadas
    var alertController: UIAlertController?   // Referencia para controlar la alerta
    var diarioEditando: DiarioEntity?  // Para saber si estamos editando un registro
    var indiceEditando: IndexPath?  // Para saber el índice del diario que estamos editando
    var tituloTextField: UITextField!
    var experienciaTextField: UITextField!
    var sentimientosTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        diarioTableView.dataSource = self
        diarioTableView.delegate = self
        listarCoreData()  // Cargar los diarios desde CoreData
    }

    // Acción para registrar un nuevo diario
    @IBAction func registerDiario(_ sender: Any) {
        diarioEditando = nil  // Si estamos registrando un nuevo diario, eliminamos la referencia al diario en edición
        alertRegisterDiario()  // Mostrar el formulario de registro
    }

    // Número de filas en el UITableView (número de diarios)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarioList.count
    }

    // Configuración de cada celda del UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarioCell", for: indexPath) as! DiarioTableViewCell

        let diario = diarioList[indexPath.row]

        // Configurar las etiquetas de la celda con los datos del diario
        cell.tituloDiarioLabel.text = diario.titulo
        cell.experienciaDiarioLabel.text = diario.experiencia
        cell.sentimientosDiarioLabel.text = diario.sentimientos

        // Mostrar la fecha en formato adecuado
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.fechaDiarioLabel.text = dateFormatter.string(from: diario.fecha ?? Date())

        // Cargar imágenes en la celda si existen
        if let imagenesData = diario.imagen, let imagenes = try? JSONDecoder().decode([Data].self, from: imagenesData) {
            let imagenesUI = imagenes.compactMap { UIImage(data: $0) }
            cell.configurarImagenes(imagenes: imagenesUI)
        }

        return cell
    }

    // Función para registrar o actualizar un diario en CoreData
    func registrarCoreData(titulo: String, experiencia: String, sentimientos: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let diario: DiarioEntity
        if let diarioEditando = diarioEditando {
            diario = diarioEditando
        } else {
            diario = DiarioEntity(context: context)
            diario.fecha = Date()
        }

        diario.titulo = titulo
        diario.experiencia = experiencia
        diario.sentimientos = sentimientos

        // Convertir las imágenes a Data
        if !imagenesSeleccionadas.isEmpty {
            let imagenesData = imagenesSeleccionadas.compactMap { $0.jpegData(compressionQuality: 0.8) }
            if let encodedImages = try? JSONEncoder().encode(imagenesData) {
                diario.imagen = encodedImages
            }
        } else {
            diario.imagen = nil  // Si no hay imágenes, aseguramos que el campo quede vacío
        }

        do {
            try context.save()
            if let indexPath = indiceEditando {
                diarioList[indexPath.row] = diario  // Actualizamos el diario en la lista
            } else {
                diarioList.append(diario)  // Si es un nuevo diario, lo agregamos
            }
        } catch let error as NSError {
            print("Se presentó un error al guardar: \(error.localizedDescription)")
        }

        diarioTableView.reloadData()
        listarCoreData()

        // Limpiar imágenes seleccionadas
        imagenesSeleccionadas.removeAll()
    }

    // Mostrar alerta para registrar o editar un diario
    func alertRegisterDiario(isEdit: Bool = false) {
        alertController = UIAlertController(title: isEdit ? "Actualizar Diario" : "Registrar Diario", message: "Agrega tus actividades y fotos", preferredStyle: .alert)

        // Agregar campos de texto para título, experiencia y sentimientos
        alertController?.addTextField { alert in
            alert.placeholder = "Ingrese Titulo"
            self.tituloTextField = alert
            if isEdit {
                self.tituloTextField.text = self.diarioEditando?.titulo
            }
        }

        alertController?.addTextField { alert in
            alert.placeholder = "Ingrese Experiencia"
            self.experienciaTextField = alert
            if isEdit {
                self.experienciaTextField.text = self.diarioEditando?.experiencia
            }
        }

        alertController?.addTextField { alert in
            alert.placeholder = "Ingrese Emociones"
            self.sentimientosTextField = alert
            if isEdit {
                self.sentimientosTextField.text = self.diarioEditando?.sentimientos
            }
        }

        // Botón para seleccionar imágenes
        let actionImagenes = UIAlertAction(title: "Seleccionar Imágenes", style: .default) { action in
            self.mostrarGaleriaDeImagenes()
        }

        // Botón para registrar o actualizar el diario
        let actionRegistrar = UIAlertAction(title: isEdit ? "Actualizar" : "Registrar", style: .default) { action in
            let titulo = self.tituloTextField.text ?? ""
            let experiencia = self.experienciaTextField.text ?? ""
            let sentimientos = self.sentimientosTextField.text ?? ""
            self.registrarCoreData(titulo: titulo, experiencia: experiencia, sentimientos: sentimientos)
        }

        let actionCancelar = UIAlertAction(title: "Cancelar", style: .cancel)

        alertController?.addAction(actionImagenes)
        alertController?.addAction(actionRegistrar)
        alertController?.addAction(actionCancelar)

        present(alertController!, animated: true, completion: nil)
    }

    // Mostrar galería de imágenes con PHPicker
    func mostrarGaleriaDeImagenes() {
        var config = PHPickerConfiguration(photoLibrary: .shared()) // Cambié esto para usar PHPicker
        config.selectionLimit = 0  // Selección ilimitada
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self  // Asignamos el delegado correctamente
        present(picker, animated: true)
    }

    // Manejar la selección de imágenes con PHPicker
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)

        var selectedImages: [UIImage] = []

        let group = DispatchGroup()

        for result in results {
            group.enter()

            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    selectedImages.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.imagenesSeleccionadas = selectedImages
            self.alertController?.dismiss(animated: true) {
                self.alertRegisterDiario(isEdit: self.diarioEditando != nil) // Regresar a la alerta después de seleccionar las imágenes
            }
        }
    }

    // Deslizar para actualizar o eliminar
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let diario = diarioList[indexPath.row]

        // Acción de eliminar
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { action, index in
            self.confirmarEliminacionDiario(diario)
        }

        // Acción de actualizar
        let editAction = UITableViewRowAction(style: .normal, title: "Actualizar") { action, index in
            self.diarioEditando = diario
            self.alertRegisterDiario(isEdit: true)
        }

        return [editAction, deleteAction]
    }

    // Confirmar eliminación del diario
    func confirmarEliminacionDiario(_ diario: DiarioEntity) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Estás seguro de que deseas eliminar este diario?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí", style: .destructive, handler: { _ in
            self.eliminarDiario(diario)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // Eliminar el diario de CoreData
    func eliminarDiario(_ diario: DiarioEntity) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        context.delete(diario)

        do {
            try context.save()
            listarCoreData()  // Recargar la tabla después de eliminar
        } catch let error as NSError {
            print("No se pudo eliminar el diario: \(error.localizedDescription)")
        }
    }

    // Cargar los diarios desde CoreData
    func listarCoreData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiarioEntity> = DiarioEntity.fetchRequest()

        do {
            diarioList = try context.fetch(fetchRequest)
            diarioTableView.reloadData()  // Recargar la tabla
        } catch let error as NSError {
            print("No se pudo cargar los diarios: \(error.localizedDescription)")
        }
    }
}
