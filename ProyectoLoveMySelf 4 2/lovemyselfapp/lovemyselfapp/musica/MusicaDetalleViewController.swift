//
//  MusicaDetalleViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 3/12/24.
//

import UIKit
import FirebaseFirestore

struct MusicaDetalle{
    var id:String
    var nombre:String
    var imagen:String
    var link:String
    var autor:String
 
    
}

class MusicaDetalleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var detalleMusicaTableView: UITableView!
    // Recibir el objeto CategoriaMusica desde el viewController anterior
    
       // Recibir el objeto CategoriaMusica desde el viewController anterior
       var categoria: CategoriaMusica?
       
       var musicaList: [MusicaDetalle] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           
           detalleMusicaTableView.dataSource = self
           detalleMusicaTableView.delegate = self
           
           // Cargar las músicas para esta categoría
           if let categoriaId = categoria?.id {
               listFirestore(categoriaId: categoriaId)
           }
       }

       // Número de filas en la tabla
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return musicaList.count
       }

       // Configurar las celdas de la tabla
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "musicDetalleCell", for: indexPath) as! MusicaDetalleTableViewCell
           let musica = musicaList[indexPath.row]
           
           cell.nombreCancionLabel.text = musica.nombre
           cell.autorCancionLabel.text = musica.autor
           cell.linkCancionLabel.text = musica.link

           if let url = URL(string: musica.imagen) {
               DispatchQueue.global().async {
                   if let data = try? Data(contentsOf: url) {
                       if let image = UIImage(data: data) {
                           DispatchQueue.main.async {
                               cell.imagenMusicaView.image = image
                           }
                       }
                   }
               }
           }
           
           return cell
       }

       // Método para manejar la selección de una celda de música
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let musica = musicaList[indexPath.row]
           
           // Abre el enlace de la música (YouTube o cualquier otra URL)
           if let url = URL(string: musica.link) {
               // Abre el enlace en el navegador (Safari o el navegador predeterminado)
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
   }

   // Firebase
   extension MusicaDetalleViewController {
       func listFirestore(categoriaId: String) {
           let db = Firestore.firestore()
           
           // Filtrar las músicas por el id de la categoría
           db.collection("musica-detalle")
               .whereField("categoriaId", isEqualTo: categoriaId)
               .getDocuments { query, error in
                   if let error = error {
                       print("Error al cargar músicas: \(error)")
                   } else {
                       let musica = query?.documents.compactMap { document -> MusicaDetalle? in
                           let data = document.data()
                           let id = document.documentID
                           guard let nombre = data["nombre"] as? String,
                                 let autor = data["autor"] as? String,
                                 let link = data["link"] as? String,
                                 let imagen = data["imagen"] as? String else {
                                     return nil
                                 }
                           return MusicaDetalle(id: id, nombre: nombre, imagen: imagen, link: link, autor: autor)
                       }
                       self.musicaList = musica ?? []
                       self.detalleMusicaTableView.reloadData()
                   }
               }
       }
   }
