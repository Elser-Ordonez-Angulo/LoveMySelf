//
//  RecuperarClaveViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 26/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RecuperarClaveViewController: UIViewController {
    
    
   
    @IBOutlet weak var recuperarclaveTextField: UITextField!
    
    
    @IBAction func recuperarclave(_ sender: Any) {
        // Verificamos que el correo no esté vacío
              guard let correo = recuperarclaveTextField.text, !correo.isEmpty else {
                  // Muestra un mensaje de error si el campo está vacío
                  showAlert(message: "Por favor ingrese su correo electrónico.")
                  return
              }

              // Verificamos si el correo está registrado en Firestore
              checkIfEmailExistsInFirestore(email: correo) { exists in
                  if exists {
                      // Si el correo está registrado en Firestore, enviamos el enlace de recuperación
                      self.sendPasswordResetLink(email: correo)
                  } else {
                      // Si el correo no está registrado, mostramos una alerta para registrarse
                      self.showRegistrationAlert()
                  }
              }
          }
          
          // Función para verificar si el correo existe en Firestore
          func checkIfEmailExistsInFirestore(email: String, completion: @escaping (Bool) -> Void) {
              let db = Firestore.firestore()
              let usersRef = db.collection("usuarios")
              
              // Consultamos si existe un documento con el correo electrónico proporcionado
              usersRef.whereField("correo", isEqualTo: email).getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Error al consultar Firestore: \(error.localizedDescription)")
                      completion(false) // Si hay error, asumimos que el correo no existe
                  } else {
                      if let snapshot = querySnapshot, !snapshot.isEmpty {
                          completion(true) // El correo existe en Firestore
                      } else {
                          completion(false) // El correo no existe en Firestore
                      }
                  }
              }
          }
          
          // Función para enviar el enlace de recuperación de contraseña a través de Firebase Auth
          func sendPasswordResetLink(email: String) {
              Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                  if let error = error {
                      // Si ocurre un error al enviar el enlace
                      self.showAlert(message: "Error al enviar el enlace: \(error.localizedDescription)")
                  } else {
                      // Si el enlace se envió correctamente, mostramos un mensaje de éxito
                      self.showAlert(message: "Te hemos enviado un enlace para recuperar tu contraseña. Revisa tu correo electrónico.")
                  }
              }
          }
          
          // Función para mostrar alertas con mensajes
          func showAlert(message: String) {
              let alert = UIAlertController(title: "Recuperar Contraseña", message: message, preferredStyle: .alert)
              
              // Botón "Aceptar"
              alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
                  // Aquí redirigimos al LoginViewController cuando el usuario presiona "Aceptar"
                  self.navigateToLogin()
              }))
              
              present(alert, animated: true, completion: nil)
          }
          
          // Función para mostrar la alerta cuando el correo no esté registrado
          func showRegistrationAlert() {
              let alert = UIAlertController(title: "Correo No Registrado", message: "El correo ingresado no está registrado. ¿Deseas registrarte?", preferredStyle: .alert)
              
              // Opción para ir al registro
              alert.addAction(UIAlertAction(title: "Registrar", style: .default, handler: { _ in
                  self.navigateToRegister()
              }))
              
              // Opción para ir al login (Cancelar) con texto en rojo
              let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: { _ in
                  self.navigateToLogin()
              })
              
              // Cambiar el color del texto del botón "Cancelar" a rojo
              cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
              alert.addAction(cancelAction)
              
              present(alert, animated: true, completion: nil)
          }
          
          // Función para navegar a la pantalla de registro
          func navigateToRegister() {
              if let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrarController") {
                  // Presentamos el controlador de registro
                  self.navigationController?.pushViewController(registerVC, animated: true)
              }
          }
          
          // Función para navegar a la pantalla de login
          func navigateToLogin() {
              if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") {
                  // Presentamos el controlador de login
                  self.navigationController?.pushViewController(loginVC, animated: true)
              }
          }
          
          // Este método es llamado cuando la vista se ha cargado
          override func viewDidLoad() {
              super.viewDidLoad()
          }
      }
