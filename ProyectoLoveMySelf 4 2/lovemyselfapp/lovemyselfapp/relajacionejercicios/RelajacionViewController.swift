//
//  RelajacionViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 22/11/24.
//

import UIKit

struct Relajacion {
    let imagen: String
    let titulo:  String
    let tiempo:  String
    
}

class RelajacionViewController: UIViewController, UITableViewDataSource{
    
    
    
    @IBOutlet weak var relajacionTableView: UITableView!
    
    var ejerciciosrelajacionList: [Relajacion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        relajacionTableView.dataSource = self //  delegado
        let relajacion1 = Relajacion(imagen: "respira", titulo: "Respiración profunda o diafragmática", tiempo: "10 minutos")
        let relajacion2 = Relajacion(imagen: "respira", titulo: "Respiración profunda o diafragmática", tiempo: "10 minutos")
        let relajacion3 = Relajacion(imagen: "respira", titulo: "Respiración profunda o diafragmática", tiempo: "10 minutos")
                       
        ejerciciosrelajacionList.append(relajacion1)
        ejerciciosrelajacionList.append(relajacion2)
        ejerciciosrelajacionList.append(relajacion3)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ejerciciosrelajacionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                       "relajacionEjerciciosCell", for: indexPath) as!
                       RelajacionTableViewCell
                       
                       let relajacion = ejerciciosrelajacionList[indexPath.row]

        cell.relajacionImageView.image = UIImage(named: relajacion.imagen)
        cell.tituloLabel.text = relajacion.titulo
        cell.tiempoLabel.text = relajacion.tiempo
                       
                       return cell
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
