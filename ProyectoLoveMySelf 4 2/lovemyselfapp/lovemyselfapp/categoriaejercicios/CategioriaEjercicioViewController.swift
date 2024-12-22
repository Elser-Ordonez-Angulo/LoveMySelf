//
//  CategioriaEjercicioViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 22/11/24.
//

import UIKit

struct categoriaEjercicio {

    let imagen: String
   
}

class CategioriaEjercicioViewController: UIViewController,UITableViewDataSource{
    
    
    
    
    @IBOutlet weak var categoriaEjercicioTableView: UITableView!
    var categoriaEjercicioList: [categoriaEjercicio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriaEjercicioTableView.dataSource = self // Delegado
        
        // Crear los ejercicios
        let categoriaEjercicio1 = categoriaEjercicio(imagen: "Tr4")
        let categoriaEjercicio2 = categoriaEjercicio(imagen: "med")
        let categoriaEjercicio3 = categoriaEjercicio(imagen: "rel")
        let categoriaEjercicio4 = categoriaEjercicio(imagen: "min")
      
        
        // Agregar ejercicios a la lista
        categoriaEjercicioList.append(contentsOf: [categoriaEjercicio1, categoriaEjercicio2,categoriaEjercicio3,categoriaEjercicio4])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriaEjercicioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriaEjercicioCell", for: indexPath) as! CategoriaEjercicioTableViewCell
        let categoriaEjercicio = categoriaEjercicioList[indexPath.row]
        
        // Asignar valores a las etiquetas e imagen
        
        cell.categoriaEjercicioImageView.image = UIImage(named:categoriaEjercicio.imagen)
        
        
        
        return cell
    }
    
}
