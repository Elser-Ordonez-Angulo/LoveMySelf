import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagenImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    
    // Ruta donde se guardará la imagen en el dispositivo
    let imagenFileName = "perfil_imagen.jpg"
    let imagenPorDefecto = UIImage(named: "perfil") // Reemplaza con el nombre de tu imagen por defecto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la imagen como circular
        configurarImagenCircular()
        
        // Añadir gesto de toque a la imagen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagenTapped))
        imagenImageView.addGestureRecognizer(tapGesture)
        imagenImageView.isUserInteractionEnabled = true
        
        // Cargar la imagen de perfil localmente
        cargarImagenDePerfil()
        
        // Llamar a la función para cargar los datos del usuario
        cargarDatosUsuario()
    }
    
    // Función para configurar la imagen como circular
    func configurarImagenCircular() {
        imagenImageView.contentMode = .scaleAspectFill
        imagenImageView.layer.cornerRadius = imagenImageView.frame.size.width / 2
        imagenImageView.clipsToBounds = true
    }
    
    // Función cuando se toca la imagen
    @objc func imagenTapped() {
        // Mostrar opciones para actualizar o borrar la foto
        let alertController = UIAlertController(title: "¿Qué deseas hacer?", message: nil, preferredStyle: .actionSheet)
        
        // Opción para actualizar la foto
        let updateAction = UIAlertAction(title: "Cambiar", style: .default) { _ in
            self.mostrarSeleccionDeImagen()
        }
        
        // Opción para borrar la foto
        let deleteAction = UIAlertAction(title: "Borrar", style: .destructive) { _ in
            self.confirmarEliminarFoto()
        }
        
        // Botón para cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        // Agregar las acciones al alert
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Mostrar el alert
        present(alertController, animated: true, completion: nil)
    }
    
    // Función para permitir la selección de una imagen
    func mostrarSeleccionDeImagen() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Puedes cambiar a .camera para usar la cámara
        
        // Mostrar el picker de imágenes
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Función que se llama cuando el usuario selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Actualizar la imagen de perfil
            imagenImageView.image = selectedImage
            // Guardar la imagen localmente
            guardarImagenLocalmente(selectedImage)
            
            // Mostrar alerta de éxito
            mostrarAlerta(titulo: "Éxito", mensaje: "Imagen actualizada correctamente", boton: "OK")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Función que se llama si el usuario cancela la selección de la imagen
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Función para guardar la imagen en el dispositivo (localmente)
    func guardarImagenLocalmente(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // Obtener la ruta del archivo
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageURL = documentsDirectory.appendingPathComponent(imagenFileName)
            
            do {
                // Guardar la imagen como archivo
                try imageData.write(to: imageURL)
            } catch {
                print("Error al guardar la imagen: \(error.localizedDescription)")
            }
        }
    }
    
    // Función para cargar la imagen desde el almacenamiento local
    func cargarImagenDePerfil() {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageURL = documentsDirectory.appendingPathComponent(imagenFileName)
            
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    imagenImageView.image = image
                }
            } else {
                // Si no hay imagen guardada, usar imagen por defecto
                imagenImageView.image = imagenPorDefecto
            }
        }
    }
    
    // Función para confirmar eliminación de la foto
    func confirmarEliminarFoto() {
        let alertController = UIAlertController(title: "¿Estás seguro?", message: "¿Deseas eliminar la foto de perfil?", preferredStyle: .alert)
        
        // Botón para eliminar
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { _ in
            self.borrarFotoPerfil()
        }
        
        // Botón para cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Mostrar alerta de eliminación
        present(alertController, animated: true, completion: nil)
    }
    
    // Función para borrar la foto de perfil
    func borrarFotoPerfil() {
        // Eliminar la imagen del sistema de archivos local
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageURL = documentsDirectory.appendingPathComponent(imagenFileName)
            do {
                try fileManager.removeItem(at: imageURL)
                print("Imagen eliminada del sistema de archivos.")
                
                // Actualizar la imagen por defecto
                imagenImageView.image = imagenPorDefecto
                
            } catch {
                print("Error al eliminar la imagen: \(error.localizedDescription)")
            }
        }
    }
    
    // Función para cargar los datos del usuario (nombre y correo)
    func cargarDatosUsuario() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userID = user.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let nombre = data?["nombres"] as? String ?? "Nombre no disponible"
                let correo = data?["correo"] as? String ?? "Correo no disponible"
                
                DispatchQueue.main.async {
                    self.nombreLabel.text = nombre
                    self.correoLabel.text = correo
                }
            } else {
                print("El documento no existe o hay un error: \(error?.localizedDescription ?? "Desconocido")")
            }
        }
    }
    
    // Función para mostrar alertas con título y mensaje
    func mostrarAlerta(titulo: String, mensaje: String, boton: String) {
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let okAction = UIAlertAction(title: boton, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Acción para cerrar sesión
    
    @IBAction func cerrarSesion(_ sender: Any) {
        let alerta = UIAlertController(title: "¿Estás seguro?", message: "¿Deseas cerrar sesión?", preferredStyle: .alert)
        
        let cerrarAction = UIAlertAction(title: "Cerrar sesión", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                self.cerrarSesionYRedirigirALogin()
            } catch let error {
                print("Error al cerrar sesión: \(error.localizedDescription)")
            }
        }
        
        let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(cerrarAction)
        alerta.addAction(cancelarAction)
        
        present(alerta, animated: true, completion: nil)
    }
    
    func cerrarSesionYRedirigirALogin() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginController") {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
        }
    }
}
