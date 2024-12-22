import UIKit
import FirebaseFirestore

// Estructura simplificada para los deportes (solo nombre e imagen)
struct Deportes {
    var nombre: String
    var imagen: String
}

class DeporteDetalleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var detalleUICollection: UICollectionView!
    
    var categoria: CategoriaDeporte?  // La categoría seleccionada
    var deportesList: [Deportes] = []  // Lista de deportes para la categoría
    
    var itemsSection: CGFloat = 1 // Número de celdas por fila
    var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // Espaciado entre celdas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el UICollectionView
        detalleUICollection.delegate = self
        detalleUICollection.dataSource = self
        
        // Cargar los deportes de Firestore para la categoría seleccionada
        if let categoria = categoria {
            loadDeportes(for: categoria)
        }
    }
    
    // Cargar deportes desde Firestore según la categoría seleccionada
    func loadDeportes(for categoria: CategoriaDeporte) {
        let db = Firestore.firestore()
        
        // Filtrar deportes por la categoría seleccionada
        db.collection("deporte")
            .whereField("categoriadeportes", isEqualTo: categoria.id)
            .getDocuments { query, error in
                if let error = error {
                    print("Error cargando deportes: \(error)")
                } else {
                    // Solo extraemos nombre e imagen
                    self.deportesList = query?.documents.compactMap { document -> Deportes? in
                        let data = document.data()
                        guard let nombre = data["nombre"] as? String,
                              let imagen = data["imagen"] as? String else {
                            return nil
                        }
                        return Deportes(nombre: nombre, imagen: imagen)
                    } ?? []
                    
                    DispatchQueue.main.async {
                        self.detalleUICollection.reloadData()
                    }
                }
            }
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deportesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let deporte = deportesList[indexPath.row]
        
        // Asignar la celda para cada deporte
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deporteCell", for: indexPath) as! DetalleEjercicioCollectionViewCell
        cell.nombreEjercicioLabel.text = deporte.nombre
        
        // Cargar la imagen del deporte de manera asincrónica
        if let url = URL(string: deporte.imagen) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imagenEjercicio.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    // Configuración del tamaño de cada celda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingLateralSpaces = insets.left + insets.right
        let widthTotal = collectionView.frame.width
        let spaceForItems = (itemsSection - 1) * 5 // Espaciado entre celdas
        let widthFree = widthTotal - paddingLateralSpaces - spaceForItems
        let width = widthFree / itemsSection
        return CGSize(width: width, height: 200) // Ajusta el tamaño de la celda
    }
    
    // Configuración del espaciado entre las celdas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Aquí puedes agregar lógica para cuando un deporte sea seleccionado
        let deporte = deportesList[indexPath.row]
        print("Deporte seleccionado: \(deporte.nombre)")
        // Puedes navegar a otra vista o hacer algo con el deporte seleccionado
    }
}
