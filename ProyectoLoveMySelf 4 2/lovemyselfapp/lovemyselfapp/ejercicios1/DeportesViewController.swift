import UIKit
import FirebaseFirestore
import PDFKit // Importar PDFKit para visualizar PDFs

// Estructura para la categoría de deporte
struct CategoriaDeporte {
    var id: String
    var nombre: String
}

// Estructura para el deporte
struct Deporte {
    var iddep: String
    var imagen: String
    var nombre: String
    var categoriaId: String
    var pdf: String? // Nuevo campo para almacenar la URL del PDF
}

class DeportesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var deportesTableView: UITableView!
    
    // Variables para almacenar las categorías de deportes y los deportes
    var categoriasdepList: [CategoriaDeporte] = []
    var itemsSection: CGFloat = 2
    var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    var deporteList: [String: [Deporte]] = [:] // Diccionario que almacena deportes por categoría
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deportesTableView.dataSource = self
        deportesTableView.delegate = self
        listCategoriasdepFromFirestore() // Cargar las categorías de Firestore
    }
    
    // MARK: - UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriasdepList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deporteCell", for: indexPath) as! DeportesTableViewCell
        let categoriadep = categoriasdepList[indexPath.row]
        cell.categoriadepLabel.text = categoriadep.nombre
        
        // Asigna un tag único al UICollectionView basado en el índice de la categoría
        cell.deporteCollectionView.tag = indexPath.row
        
        // Asignar la colección de deportes a la celda
        if let deporteCollection = deporteList[categoriadep.id] {
            cell.deporteCollectionView.delegate = self
            cell.deporteCollectionView.dataSource = self
            cell.deporteCollectionView.reloadData()
        }
        
        return cell
    }
    
    // MARK: - UICollectionView DataSource & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoriadep = categoriasdepList[collectionView.tag]
        return deporteList[categoriadep.id]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoriadep = categoriasdepList[collectionView.tag]
        let deporte = deporteList[categoriadep.id]?[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deporteCell", for: indexPath) as! DeportesCollectionViewCell
        cell.nombredepLabel.text = deporte?.nombre
        
        // Cargar la imagen del deporte
        if let url = URL(string: deporte?.imagen ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.deporteImageView.image = image
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
        let spaceForItems = (itemsSection - 1) * 5
        let widthFree = widthTotal - paddingLateralSpaces - spaceForItems
        let width = widthFree / itemsSection
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoriadep = categoriasdepList[collectionView.tag]
        let deporte = deporteList[categoriadep.id]?[indexPath.row]
        
        // Verificar si el deporte tiene un PDF
        if let pdfURL = deporte?.pdf {
            guard let url = URL(string: pdfURL) else {
                print("Invalid PDF URL")
                return
            }
            openPDF(from: url)
        }
    }
    
    // MARK: - Firebase Firestore
    
    // Función para cargar las categorías desde Firestore
    func listCategoriasdepFromFirestore() {
        let db = Firestore.firestore()
        db.collection("categoriadeportes").getDocuments { query, error in
            if let error = error {
                print("Error cargando categorías: \(error)")
            } else {
                let categoriasdep = query?.documents.compactMap { document -> CategoriaDeporte? in
                    let data = document.data()
                    guard let nombre = data["nombre"] as? String else {
                        return nil
                    }
                    return CategoriaDeporte(id: document.documentID, nombre: nombre)
                }
                self.categoriasdepList = categoriasdep ?? []
                print("Categorías cargadas: \(self.categoriasdepList)") // Verifica las categorías
                
                // Cargar los deportes después de obtener las categorías
                self.listDeportesFromFirestore()
            }
        }
    }
    
    // Función para cargar los deportes de cada categoría desde Firestore
    func listDeportesFromFirestore() {
        let db = Firestore.firestore()
        
        for categoriadep in categoriasdepList {
            db.collection("deporte")
                .whereField("categoriadeportes", isEqualTo: categoriadep.id) // Filtrar deportes por categoría
                .getDocuments { query, error in
                    if let error = error {
                        print("Error cargando deportes: \(error)")
                    } else {
                        let deportes = query?.documents.compactMap { document -> Deporte? in
                            let data = document.data()
                            guard let nombre = data["nombre"] as? String,
                                  let imagen = data["imagen"] as? String else {
                                return nil
                            }
                            
                            // Obtener el campo PDF, si existe
                            let pdf = data["pdf"] as? String
                            
                            return Deporte(iddep: document.documentID, imagen: imagen, nombre: nombre, categoriaId: categoriadep.id, pdf: pdf)
                        }
                        
                        // Guardar los deportes bajo la categoría correspondiente
                        self.deporteList[categoriadep.id] = deportes ?? []
                        print("Deportes para la categoría \(categoriadep.nombre): \(self.deporteList[categoriadep.id] ?? [])") // Verifica los deportes
                    }
                    
                    // Recargar la tabla después de obtener todos los deportes
                    DispatchQueue.main.async {
                        self.deportesTableView.reloadData()
                    }
                }
        }
    }
    
    // MARK: - Función para abrir el PDF
    
    // Función para abrir el PDF en una vista con PDFKit
    func openPDF(from url: URL) {
        let pdfViewController = UIViewController()
        pdfViewController.view.backgroundColor = .white

        // Crear el PDFView y configurarlo
        let pdfView = PDFView(frame: pdfViewController.view.bounds)
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        if let pdfDocument = PDFDocument(url: url) {
            pdfView.document = pdfDocument
        } else {
            print("Unable to load PDF document")
            return
        }

        // Añadir el PDFView a la vista del controlador
        pdfViewController.view.addSubview(pdfView)

        // Configurar restricciones para PDFView
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: pdfViewController.view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: pdfViewController.view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: pdfViewController.view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pdfViewController.view.bottomAnchor)
        ])

        // Navegar al controlador de PDFView
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
}
