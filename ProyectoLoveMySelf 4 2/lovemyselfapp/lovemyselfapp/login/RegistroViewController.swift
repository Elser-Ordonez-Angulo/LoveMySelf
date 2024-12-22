import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var nombresTextField: UITextField!
    @IBOutlet weak var apellidosTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var claveTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registrar(_ sender: Any) {
        let nombres = nombresTextField.text!
        let apellidos = apellidosTextField.text!
        let correo = correoTextField.text!
        let clave = claveTextField.text!
        
        // Validación de campos vacíos
        if nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || clave.isEmpty {
            self.showAlertError(message: "Todos los campos son obligatorios.")
            return
        }
        
        // Llamar al registro de autenticación
        registerAuth(nombres: nombres, apellidos: apellidos, correo: correo, clave: clave)
    }
    
    private func registerAuth(nombres: String, apellidos: String, correo: String, clave: String) {
        let auth = Auth.auth()
        
        // Intentamos crear el usuario en Firebase Auth
        auth.createUser(withEmail: correo, password: clave) { (result, error) in
            if let error = error {
                // Manejar el error si el correo ya está registrado
                if let authError = error as? NSError, authError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.showAlertError(message: "El correo ya está registrado. Por favor, ingresa uno diferente.")
                } else {
                    self.showAlertError(message: "Error al crear la cuenta. Por favor, intente nuevamente.")
                }
            } else if let user = result {
                // Si el usuario se creó correctamente en Auth, registramos sus datos en Firestore
                let uid = user.user.uid
                self.registerFirestore(uid: uid, nombres: nombres, apellidos: apellidos, correo: correo)
            }
        }
    }
    
    private func registerFirestore(uid: String, nombres: String, apellidos: String, correo: String) {
        let db = Firestore.firestore()
        
        // Guardamos los datos en Firestore
        db.collection("usuarios").document(uid).setData([
            "nombres": nombres,
            "apellidos": apellidos,
            "correo": correo
        ]) { error in
            if let error = error {
                // Si hubo un error al guardar los datos en Firestore
                self.showAlertError(message: "Hubo un error al guardar los datos. Intenta nuevamente.")
            } else {
                // Registro exitoso, mostramos la alerta de éxito
                self.showAlertSuccess()
            }
        }
    }
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func showAlertSuccess() {
        // Mostrar la alerta de éxito
        let alert = UIAlertController(title: "Registro exitoso", message: "Te has registrado correctamente. Ahora puedes iniciar sesión.", preferredStyle: .alert)
        
        // Agregar un botón verde para continuar al login
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Navegar al login después de un registro exitoso y cerrar todas las pantallas previas
            self.navigateToLogin()
        }
        
        // Cambiar el color del botón a verde
        okAction.setValue(UIColor.green, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        
        // Presentar la alerta
        self.present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        // Asegúrate de que el Storyboard ID del LoginViewController sea correcto en el Storyboard.
        // Aquí, usamos el storyboard y el identificador correcto para navegar al LoginViewController
        
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") {
            // Cerrar todas las pantallas abiertas (popToRootViewController)
            self.navigationController?.popToRootViewController(animated: false)
            
            // Usamos el método `present` para mostrar el LoginViewController si no estamos en un UINavigationController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
