//
//  ResultViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 5/12/24.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    

    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    // Variables para recibir datos del controlador anterior
           var resultText: String = ""
           var resultImageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mostrar el resultado
                       resultLabel.text = resultText
                       resultImageView.image = UIImage(named: resultImageName)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resultHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
