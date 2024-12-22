//
//  MusicgeneralViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 15/11/24.
//

import UIKit

struct Musicgeneral {
    let imagen1: String
    let categoria1:  String
    let imagen2: String
    let categoria2:  String
    
}

class MusicgeneralViewController: UIViewController, UITableViewDataSource{
    
    
    
    
    
    @IBOutlet weak var musicgeneralTableView: UITableView!
    
    var musicgeneralesList: [Musicgeneral] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        musicgeneralTableView.dataSource = self //  delegado
                        let musicgeneral1 = Musicgeneral(imagen1: "clasica", categoria1: "Clásica ", imagen2: "musicag2", categoria2: "Instrumental")
                let musicgeneral2 = Musicgeneral(imagen1: "naturaleza", categoria1: "Naturaleza", imagen2: "jazz", categoria2: "Jazz lento")
                let musicgeneral3 = Musicgeneral(imagen1: "clasica", categoria1: "Clásica ", imagen2: "musicag2", categoria2: "Instrumental")
                       
                        
                        
                                
                musicgeneralesList.append(musicgeneral1)
                musicgeneralesList.append(musicgeneral2)
                musicgeneralesList.append(musicgeneral3)

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicgeneralesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                       "musicgeneralCell", for: indexPath) as!
                       MusicgeneralTableViewCell
                       
                       let musicgeneral = musicgeneralesList[indexPath.row]
                       
                cell.categoria1Label.text = musicgeneral.categoria1
                cell.musicimg1ImageView.image = UIImage(named: musicgeneral.imagen1)
                cell.categoria2Label.text = musicgeneral.categoria2
                cell.musicimg2ImageView.image = UIImage(named: musicgeneral.imagen2)
                       
                       return cell
            }

}
