import UIKit
import FirebaseFirestore

class InicioViewController: UIViewController {
    
    @IBOutlet weak var carruselCollectionView: UICollectionView!
    @IBOutlet weak var testCollectionView: UICollectionView!
    @IBOutlet weak var articulosCollectionView: UICollectionView!
    @IBOutlet weak var ejerciciosCollectionView: UICollectionView!
    
    var carruselImages: [String] = []
    var testImages: [String] = []
    var articulosImages: [String] = []
    var ejerciciosImages: [String] = []
    
    var carruselTimer: Timer?
    var testTimer: Timer?
    var articulosTimer: Timer?
    var ejerciciosTimer: Timer?
    var ejerciciosDirectionForward: Bool = true
    

    //alerta de test
    
    @IBAction func alertTest(_ sender: Any) {
        alertTestt()
        
    }
    
    @IBOutlet weak var alertaTest: UIButton!
    
    
    
    
    
    // Dirección del scroll para ejercicios

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        // Configurar delegados y data source para todas las colecciones
        [carruselCollectionView, testCollectionView, articulosCollectionView, ejerciciosCollectionView].forEach { collectionView in
            collectionView?.dataSource = self
            collectionView?.delegate = self
            setupCollectionViewLayout(collectionView: collectionView)
        }

        // Cargar imágenes desde Firebase
        fetchCarruselImages()
        fetchTestImages()
        fetchArticulosImages()
        fetchEjerciciosImages()

        // Configurar autoscroll para todas las colecciones
        setupCarruselAutoScroll()
        setupTestAutoScroll()
        setupArticulosAutoScroll()
        setupEjerciciosAutoScroll()
    }

    // MARK: - Configuración del layout
    func setupCollectionViewLayout(collectionView: UICollectionView?) {
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10 // Espacio entre celdas
        }
    }

    // MARK: - Firebase: Cargar imágenes
    func fetchCarruselImages() {
        let db = Firestore.firestore()
        db.collection("carrucel").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error al cargar imágenes del carrusel: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.carruselImages = documents.compactMap { $0.data()["imagen"] as? String }
            DispatchQueue.main.async {
                self.carruselCollectionView.reloadData()
            }
        }
    }

    func fetchTestImages() {
        let db = Firestore.firestore()
        db.collection("carruceltest").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error al cargar imágenes del test: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.testImages = documents.compactMap { $0.data()["imagen"] as? String }
            DispatchQueue.main.async {
                self.testCollectionView.reloadData()
            }
        }
    }

    func fetchArticulosImages() {
        let db = Firestore.firestore()
        db.collection("carrucelarticulos").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error al cargar imágenes de artículos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.articulosImages = documents.compactMap { $0.data()["imagen"] as? String }
            DispatchQueue.main.async {
                self.articulosCollectionView.reloadData()
            }
        }
    }

    func fetchEjerciciosImages() {
        let db = Firestore.firestore()
        db.collection("carrucelejercicios").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error al cargar imágenes de ejercicios: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.ejerciciosImages = documents.compactMap { $0.data()["imagen"] as? String }
            DispatchQueue.main.async {
                self.ejerciciosCollectionView.reloadData()
            }
        }
    }

    // MARK: - Configuración de autoscroll
    func setupCarruselAutoScroll() {
        carruselTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollCarrusel), userInfo: nil, repeats: true)
    }

    @objc func scrollCarrusel() {
        scrollCollectionView(collectionView: carruselCollectionView, images: carruselImages)
    }

    func setupTestAutoScroll() {
        testTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollTest), userInfo: nil, repeats: true)
    }

    @objc func scrollTest() {
        scrollCollectionView(collectionView: testCollectionView, images: testImages)
    }

    func setupArticulosAutoScroll() {
        articulosTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(scrollArticulos), userInfo: nil, repeats: true)
    }

    @objc func scrollArticulos() {
        scrollCollectionView(collectionView: articulosCollectionView, images: articulosImages)
    }

    func setupEjerciciosAutoScroll() {
        ejerciciosTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollEjercicios), userInfo: nil, repeats: true)
    }

    @objc func scrollEjercicios() {
        scrollCollectionViewWithReverse(collectionView: ejerciciosCollectionView, images: ejerciciosImages, directionForward: &ejerciciosDirectionForward)
    }

    // MARK: - Scroll automático
    func scrollCollectionView(collectionView: UICollectionView, images: [String]) {
        guard images.count > 1 else { return }
        let currentOffset = collectionView.contentOffset.x
        let nextOffset = currentOffset + collectionView.bounds.width / 2
        if nextOffset < collectionView.contentSize.width {
            collectionView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
        } else {
            collectionView.setContentOffset(.zero, animated: true)
        }
    }

    func scrollCollectionViewWithReverse(collectionView: UICollectionView, images: [String], directionForward: inout Bool) {
        guard images.count > 1 else { return }
        let currentOffset = collectionView.contentOffset.x
        let step = collectionView.bounds.width / 2

        if directionForward {
            let nextOffset = currentOffset + step
            if nextOffset < collectionView.contentSize.width {
                collectionView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
            } else {
                directionForward = false
                collectionView.setContentOffset(CGPoint(x: currentOffset - step, y: 0), animated: true)
            }
        } else {
            let previousOffset = currentOffset - step
            if previousOffset >= 0 {
                collectionView.setContentOffset(CGPoint(x: previousOffset, y: 0), animated: true)
            } else {
                directionForward = true
                collectionView.setContentOffset(CGPoint(x: currentOffset + step, y: 0), animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource y Delegate
extension InicioViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case carruselCollectionView: return carruselImages.count
        case testCollectionView: return testImages.count
        case articulosCollectionView: return articulosImages.count
        case ejerciciosCollectionView: return ejerciciosImages.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case carruselCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carrucelCell", for: indexPath) as! CarruselCollectionViewCell
            configureCell(cell: cell, imageUrl: carruselImages[indexPath.row])
            return cell
        case testCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagenesTestCell", for: indexPath) as! ImagenesTestCollectionViewCell
            configureCell(cell: cell, imageUrl: testImages[indexPath.row])
            return cell
        case articulosCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagenesArticulosCell", for: indexPath) as! ImagenArticulosCollectionViewCell
            configureCell(cell: cell, imageUrl: articulosImages[indexPath.row])
            return cell
        case ejerciciosCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagenesEjerciciosCell", for: indexPath) as! ImagenEjerciciosCollectionViewCell
            configureCell(cell: cell, imageUrl: ejerciciosImages[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func configureCell(cell: UICollectionViewCell, imageUrl: String) {
        if let imageViewCell = cell as? CarruselCollectionViewCell {
            loadImage(imageUrl: imageUrl, into: imageViewCell.carrucelImageView)
        } else if let imageViewCell = cell as? ImagenesTestCollectionViewCell {
            loadImage(imageUrl: imageUrl, into: imageViewCell.testImageview)
        } else if let imageViewCell = cell as? ImagenArticulosCollectionViewCell {
            loadImage(imageUrl: imageUrl, into: imageViewCell.articulosImageView)
        } else if let imageViewCell = cell as? ImagenEjerciciosCollectionViewCell {
            loadImage(imageUrl: imageUrl, into: imageViewCell.ejerciciomagenView)
        }
    }

    func loadImage(imageUrl: String, into imageView: UIImageView) {
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error al cargar imagen: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            imageView.image = UIImage(systemName: "imagen") // Imagen de marcador de posición
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func alertTestt() {
                let alert = UIAlertController(title: "Alerta de Test", message: "Este test no pretende dar un resultado 100% médico", preferredStyle: .alert)
                
                let actionAceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
                    // Crear la pantalla de test y presentarla
                    if let testVC = self.storyboard?.instantiateViewController(withIdentifier: "CuestionViewController") as? CuestionViewController {
                        self.navigationController?.pushViewController(testVC, animated: true)
                    }
                }
                
                alert.addAction(actionAceptar)
                
                // Mostrar la alerta
                present(alert, animated: true)
            }
}
