//
//  LoginViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 26/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var claveTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func ingresar(_ sender: Any) {
        let correo = correoTextField.text!
                let clave = claveTextField.text!
                verifyFirebase(email: correo, pass: clave)
            }
            private func verifyFirebase(email: String, pass: String){
                //login firebase
                let auth = Auth.auth()
                auth.signIn(withEmail: email, password: pass){ (result, error)in
                    if let user = result{
                        let uid = user.user.uid
                        let userDefault = UserDefaults.standard.set(true, forKey: "login")
                        self.goToPrincipal()
                    }else{
                        self.showAlertError()
                    }
                }
            }
            private func showAlertError(){
                //alerta de erro en inicio de sesion
                let alert = UIAlertController(title: "Error", message: "Verifique bien sus credenciales", preferredStyle: .alert)
                let action = UIAlertAction(title: "Entendido", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            private func goToPrincipal(){
                //permite ir al menu principal
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyBoard.instantiateViewController(identifier: "PrincipalView") as!
                BienvenidoViewController
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true)
            }
        }
