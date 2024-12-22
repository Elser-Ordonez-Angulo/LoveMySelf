//
//  ComentariosViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 3/12/24.
//

import UIKit
import Firebase
import FirebaseFirestore

struct Comentarios {
    var apodo: String
    var experiencia: String
    var sugerencia: String
}

class ComentariosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ComentariosTableView: UITableView!
    
    var comentList: [Comentarios] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ComentariosTableView.dataSource = self
        ComentariosTableView.delegate = self
        listFirestore()
        setupAddButton()
    }
    
    // Configurar botón para agregar comentarios
    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddCommentAlert))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func showAddCommentAlert() {
        let alert = UIAlertController(title: "Nuevo Comentario", message: "Ingrese su comentario", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Apodo"
        }
        alert.addTextField { textField in
            textField.placeholder = "Experiencia"
        }
        alert.addTextField { textField in
            textField.placeholder = "Sugerencia"
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let apodo = alert.textFields?[0].text, !apodo.isEmpty,
                  let experiencia = alert.textFields?[1].text, !experiencia.isEmpty,
                  let sugerencia = alert.textFields?[2].text, !sugerencia.isEmpty else {
                self.showErrorAlert()
                return
            }
            
            self.addCommentToFirestore(apodo: apodo, experiencia: experiencia, sugerencia: sugerencia)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Todos los campos son obligatorios.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func addCommentToFirestore(apodo: String, experiencia: String, sugerencia: String) {
        let db = Firestore.firestore()
        let newComment = ["apodo": apodo, "experiencia": experiencia, "sugerencia": sugerencia]
        
        db.collection("comentarios").addDocument(data: newComment) { error in
            if let error = error {
                print("Error al agregar comentario: \(error.localizedDescription)")
            } else {
                print("Comentario agregado con éxito")
                self.listFirestore() // Recargar datos
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComentariosViewCell", for: indexPath) as! ComentariosTableViewCell
        let comentarios = comentList[indexPath.row]
        cell.Apodo.text = comentarios.apodo
        cell.Experiencia.text = comentarios.experiencia
        cell.Sugerencia.text = comentarios.sugerencia
        
        return cell
    }
}

// Firebase
extension ComentariosViewController {
    func listFirestore() {
        let db = Firestore.firestore()
        db.collection("comentarios").getDocuments { query, error in
            if let error = error {
                print("Se presentó un error: \(error.localizedDescription)")
            } else {
                let comentarios = query?.documents.compactMap { document -> Comentarios? in
                    let data = document.data()
                    guard let apodo = data["apodo"] as? String,
                          let experiencia = data["experiencia"] as? String,
                          let sugerencia = data["sugerencia"] as? String else {
                        return nil
                    }
                    return Comentarios(apodo: apodo, experiencia: experiencia, sugerencia: sugerencia)
                }
                DispatchQueue.main.async {
                    self.comentList = comentarios ?? []
                    self.ComentariosTableView.reloadData()
                }
            }
        }
    }
}
