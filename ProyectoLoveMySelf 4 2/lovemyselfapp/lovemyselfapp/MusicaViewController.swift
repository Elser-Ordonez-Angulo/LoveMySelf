

import UIKit

struct Musica {
    
    let imagen: String
    let nombre: String
    let autor: String
    let link: String
 
    
    
}

class MusicaViewController: UIViewController, UITableViewDataSource{
    
    
    
    @IBOutlet weak var MusicaTableView: UITableView!
    var musicaList: [Musica]=[]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MusicaTableView.dataSource = self
        
        let Cancion1 = Musica(imagen: "musica1", nombre: "Luz de paz", autor: "Adele", link: "https://youtu.be/T8k9ZyE4wm4?si=Kt-5lMvV09EpxLgv")
        let Cancion2 = Musica(imagen: "musica2", nombre: "Un momento de calma", autor: "Francis", link: "https://youtu.be/T8k9ZyE4wm4?si=Kt-5lMvV09EpxLgv")
        let Cancion3 = Musica(imagen: "musica3", nombre: "Solo tu", autor: "Billi", link: "https://youtu.be/T8k9ZyE4wm4?si=Kt-5lMvV09EpxLgv")


        musicaList.append(Cancion1)
        musicaList.append(Cancion2)
        musicaList.append(Cancion3)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicaCell", for: indexPath) as! MusicaDetalleTableViewCell
        
        let musica = musicaList[indexPath.row]
        
        cell.imagenMusicaView.image = UIImage(named: musica.imagen)
        cell.nombreCancionLabel.text = musica.nombre
        cell.autorCancionLabel.text = musica.autor
        cell.linkCancionLabel.text = musica.link
        
        return cell
    }
    
    

}
