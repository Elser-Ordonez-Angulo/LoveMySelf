import UIKit
import FirebaseFirestore

// Estructura para la categoría de música
struct CategoriaMusica {
    var id: String
    var nombre: String
}

// Estructura para la música
struct Musica {
    var id: String
    var nombre: String
    var autor: String
    var urlVideo: String
    var imagenUrl: String
    var categoriaId: String
}

class MusicaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var musicaTableView: UITableView!
    
    var categoriasList: [CategoriaMusica] = []
    var itemsSection: CGFloat = 3
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    var musicaList: [String: [Musica]] = [:]  // Diccionario de músicas por categoría
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicaTableView.dataSource = self
        musicaTableView.delegate = self
        listCategoriasFromFirestore() // Cargar las categorías de Firestore
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriaMusicaCell", for: indexPath) as! MusicaTableViewCell
        let categoria = categoriasList[indexPath.row]
        cell.categoriaLabel.text = categoria.nombre
        
        // Asigna un tag único al UICollectionView basado en el índice de la categoría
        cell.musicaColectionView.tag = indexPath.row
        
        // Asignar la colección de música a la celda
        if let musicaCollection = musicaList[categoria.id] {
            cell.musicaColectionView.delegate = self
            cell.musicaColectionView.dataSource = self
            cell.musicaColectionView.reloadData()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Puedes usar este método si deseas manejar la selección de categorías
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoria = categoriasList[collectionView.tag]
        return musicaList[categoria.id]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoria = categoriasList[collectionView.tag]
        let musica = musicaList[categoria.id]?[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! MusicaCollectionViewCell
        cell.nombreLabel.text = musica?.nombre
        cell.autorLabel.text = musica?.autor
        
        // Cargar la imagen de la música
        if let url = URL(string: musica?.imagenUrl ?? "") {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingLateralSpaces = insets.left + insets.right
        let widthTotal = collectionView.frame.width
        let spaceForItems = (itemsSection - 1) * 10
        let widthFree = widthTotal - paddingLateralSpaces - spaceForItems
        let width = widthFree / itemsSection
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoria = categoriasList[collectionView.tag]
        let musica = musicaList[categoria.id]?[indexPath.row]
        
        if let url = URL(string: musica?.urlVideo ?? "") {
            // Aquí puedes abrir el video usando un WebView o un AVPlayer
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Firebase
    
    func listCategoriasFromFirestore() {
        let db = Firestore.firestore()
        db.collection("categoriamusica").getDocuments { query, error in
            if let error = error {
                print("Error cargando categorías: \(error)")
            } else {
                let categorias = query?.documents.compactMap { document -> CategoriaMusica? in
                    let data = document.data()
                    guard let nombre = data["nombre"] as? String else {
                        return nil
                    }
                    return CategoriaMusica(id: document.documentID, nombre: nombre)
                }
                self.categoriasList = categorias ?? []
                print("Categorías cargadas: \(self.categoriasList)") // Verifica las categorías
                
                // Cargar músicas después de obtener las categorías
                self.listMusicasFromFirestore()  // Asegúrate de que esto solo se llame después de cargar las categorías
            }
        }
    }
    
    func listMusicasFromFirestore() {
        let db = Firestore.firestore()
        
        for categoria in categoriasList {
            db.collection("musica")
                .whereField("categoriamusica", isEqualTo: categoria.id) // Filtrar músicas por categoría
                .getDocuments { query, error in
                    if let error = error {
                        print("Error cargando músicas: \(error)")
                    } else {
                        let musicas = query?.documents.compactMap { document -> Musica? in
                            let data = document.data()
                            guard let nombre = data["nombre"] as? String,
                                  let autor = data["autor"] as? String,
                                  let urlVideo = data["url"] as? String,
                                  let imagenUrl = data["imagen"] as? String else {
                                return nil
                            }
                            return Musica(id: document.documentID, nombre: nombre, autor: autor, urlVideo: urlVideo, imagenUrl: imagenUrl, categoriaId: categoria.id)
                        }
                        // Guardar músicas en el diccionario bajo la categoría correspondiente
                        self.musicaList[categoria.id] = musicas ?? []
                        print("Músicas para la categoría \(categoria.nombre): \(self.musicaList[categoria.id] ?? [])") // Verifica las músicas
                    }
                    
                    // Recargar la tabla después de obtener todas las músicas
                    DispatchQueue.main.async {
                        self.musicaTableView.reloadData()
                    }
                }
        }
    }
}
