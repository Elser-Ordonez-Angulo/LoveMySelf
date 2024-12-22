//
//  MindViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 22/11/24.
//

import UIKit

struct Mind {
    let imagen: String
    let titulo:  String
    let tiempo:  String
    
}


class MindViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var mindTableView: UITableView!
    
    var mindsList: [Mind] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mindTableView.dataSource = self //  delegado
        let mind1 = Mind(imagen: "minds1", titulo: "Meditación plena", tiempo: "15 minutos")
        let mind2 = Mind(imagen: "mind2", titulo: "Meditación plena", tiempo: "15 minutos")
        let mind3 = Mind(imagen: "mind3", titulo: "Meditación plena", tiempo: "15 minutos")
                       
        mindsList.append(mind1)
        mindsList.append(mind2)
        mindsList.append(mind3)


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mindsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                       "mindCell", for: indexPath) as!
                       MindTableViewCell
                       
                       let mind = mindsList[indexPath.row]

        cell.mindImageView.image = UIImage(named: mind.imagen)
        cell.tituloMindLabel.text = mind.titulo
        cell.tiempoMindLabel.text = mind.tiempo
                       
                       return cell
    }
    

   

}
