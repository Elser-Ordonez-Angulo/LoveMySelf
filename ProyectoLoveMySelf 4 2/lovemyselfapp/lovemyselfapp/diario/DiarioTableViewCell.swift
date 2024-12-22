import UIKit

class DiarioTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var fechaDiarioLabel: UILabel!
    @IBOutlet weak var tituloDiarioLabel: UILabel!
    @IBOutlet weak var experienciaDiarioLabel: UILabel!
    @IBOutlet weak var sentimientosDiarioLabel: UILabel!
    @IBOutlet weak var diarioCollectionView: UICollectionView!
    
    var imagenes: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        diarioCollectionView.delegate = self
        diarioCollectionView.dataSource = self
        
        // Configura el layout del collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100) // Tamaño de las imágenes
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        diarioCollectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diarioCollectionCell", for: indexPath) as! DiarioCollectionViewCell
        cell.imagenImageView.image = imagenes[indexPath.row]
        return cell
    }
    
    func configurarImagenes(imagenes: [UIImage]) {
        self.imagenes = imagenes
        diarioCollectionView.reloadData()
    }
}
