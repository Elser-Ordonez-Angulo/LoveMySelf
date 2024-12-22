//
//  BienvenidoViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 15/11/24.
//

import UIKit

class BienvenidoViewController: UIViewController {
    
    
    @IBAction func botonalertBienvenido(_ sender: Any) {
        alertBasic()
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func alertBasic(){
                let alert = UIAlertController(title: "APP DE SALUD MENTAL", message: "Esta alerta se presenta por motivos especificos de nuestra aplicacion, esta app ha sido creada con la finalidad de ayudar a los usuarios con problemas relacionados a la ansiedad, el estres y la depresion, tenemos presente que el contenido no es 100% medico, para brindar el contenido de la app se ha realizado una investigacion con fines sociales.", preferredStyle: .alert)
                
                let actionAceptar =  UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(actionAceptar)
                
               present(alert, animated: true)
                
                
            }

}
