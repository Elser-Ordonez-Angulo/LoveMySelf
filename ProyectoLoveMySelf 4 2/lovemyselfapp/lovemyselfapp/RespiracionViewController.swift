//
//  RespiracionViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 21/11/24.
//

import UIKit

struct Respiracion {
    let imagen1: String
    let ejercicio: String
    let duracion: String
}


class RespiracionViewController: UIViewController , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return respiracionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RespiracionCell", for: indexPath) as! RespiracionTableViewCell
        
        let respiracion = respiracionList[indexPath.row]
        
        cell.Ejercicio.text = respiracion.ejercicio
        cell.Duracion.text = respiracion.duracion
        cell.Imagen1.image = UIImage(named: respiracion.imagen1)
        return cell
    }
    
    
    @IBOutlet weak var RespiracionTableView: UITableView!
    
    var respiracionList: [Respiracion]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RespiracionTableView.dataSource = self
        
        
        let respiracion1 = Respiracion(imagen1: "des", ejercicio: "Resoplidos rapidos", duracion: "30 segundos")
        let respiracion2 = Respiracion(imagen1: "hombro", ejercicio: "Giro de hombros", duracion: "15 segundos")
        let respiracion3 = Respiracion(imagen1: "tos", ejercicio: "Tos con soporte ", duracion: "5 veces")
        let respiracion4 = Respiracion(imagen1: "diafa", ejercicio: "Respiración diafragmática", duracion: "30 segundos")
        
        
        respiracionList.append(respiracion1)
        respiracionList.append(respiracion2)
        respiracionList.append(respiracion3)
        respiracionList.append(respiracion4)

    }
    

    

}
