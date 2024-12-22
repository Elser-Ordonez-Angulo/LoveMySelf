//
//  CategoriaMusicaViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 3/12/24.
//

import UIKit
import FirebaseFirestore

struct CategoriaMusica{
    var id:String
    var nombre:String
    var imagen:String
 
    
}

class CategoriaMusicaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var categoriaMusicaTableView: UITableView!
    
    var categoriaList: [CategoriaMusica] = []

      override func viewDidLoad() {
          super.viewDidLoad()
          categoriaMusicaTableView.dataSource = self
          categoriaMusicaTableView.delegate = self
          listFirestore()
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return categoriaList.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "categoriaMusicaCell", for: indexPath) as! CategoriaMusicaTableViewCell
          let categoria = categoriaList[indexPath.row]
          cell.nombreLabel.text = categoria.nombre
          
          if let url = URL(string: categoria.imagen) {
              DispatchQueue.global().async {
                  if let data = try? Data(contentsOf: url) {
                      if let image = UIImage(data: data) {
                          DispatchQueue.main.async {
                              cell.imagenImageView.image = image
                          }
                      }
                  }
              }
          }
          
          return cell
      }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let categoria = categoriaList[indexPath.row]
          
          // Crear el controlador de la vista de música
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let view = storyboard.instantiateViewController(withIdentifier: "musicaDetalleView") as? MusicaDetalleViewController {
              // Pasar la categoría seleccionada a la vista de detalles
              view.categoria = categoria
              // Navegar a la vista de detalles
              self.navigationController?.pushViewController(view, animated: true)
          }
      }

  }

  // Firebase
  extension CategoriaMusicaViewController {
      func listFirestore() {
          let db = Firestore.firestore()
          
          // Obtener las categorías desde Firestore
          db.collection("categoria-musica").getDocuments { query, error in
              if let error = error {
                  print("Se presentó un error al cargar las categorías: \(error)")
              } else {
                  let categoria = query?.documents.compactMap { document -> CategoriaMusica? in
                      let data = document.data()
                      let id = document.documentID
                      guard let nombre = data["nombre"] as? String,
                            let imagen = data["imagen"] as? String else {
                                return nil
                            }
                      return CategoriaMusica(id: id, nombre: nombre, imagen: imagen)
                  }
                  self.categoriaList = categoria ?? []
                  self.categoriaMusicaTableView.reloadData()
              }
          }
      }
  }
