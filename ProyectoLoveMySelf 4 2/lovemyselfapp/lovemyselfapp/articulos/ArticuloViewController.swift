import UIKit
import FirebaseFirestore
import PDFKit // Para visualizar PDFs

struct Articulo {
    let titulo: String
    let imagenURL: String
    let fecha: String
    let autor: String
    let contenido: String
    let pdfURL: String
}

class ArticuloViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var articuloTableView: UITableView!

    var articulosList: [Articulo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        articuloTableView.dataSource = self
        articuloTableView.delegate = self
        fetchArticulos()
    }

    func fetchArticulos() {
        let db = Firestore.firestore()

        db.collection("articulos").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.articulosList = documents.compactMap { document -> Articulo? in
                let data = document.data()
                guard let titulo = data["titulo"] as? String,
                      let imagenURL = data["imagen"] as? String,
                      let fecha = data["fecha"] as? String,
                      let autor = data["autor"] as? String,
                      let contenido = data["contenido"] as? String,
                      let pdfURL = data["pdf"] as? String else {
                          return nil
                      }
                return Articulo(titulo: titulo, imagenURL: imagenURL, fecha: fecha, autor: autor, contenido: contenido, pdfURL: pdfURL)
            }

            DispatchQueue.main.async {
                self.articuloTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articulosList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articuloCell", for: indexPath) as! ArticuloTableViewCell

        let articulo = articulosList[indexPath.row]
        cell.tituloArticuloLabel.text = articulo.titulo
        cell.fechaArticuloLabel.text = articulo.fecha
        cell.autorArticuloLabel.text = articulo.autor
        cell.contenidoArticuloLabel.text = articulo.contenido

        // Cargar imagen desde URL
        if let url = URL(string: articulo.imagenURL) {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    cell.articuloImageView.image = image ?? UIImage(systemName: "photo")
                }
            }
        } else {
            cell.articuloImageView.image = UIImage(systemName: "photo") // Imagen por defecto si la URL es inválida
        }

        return cell
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                completion(UIImage(data: data))
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articulo = articulosList[indexPath.row]

        guard let pdfURL = URL(string: articulo.pdfURL) else {
            print("Invalid PDF URL")
            return
        }

        openPDF(from: pdfURL)
    }

    func openPDF(from url: URL) {
        let pdfViewController = UIViewController()
        pdfViewController.view.backgroundColor = .white

        let pdfView = PDFView(frame: pdfViewController.view.bounds)
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        if let pdfDocument = PDFDocument(url: url) {
            pdfView.document = pdfDocument
        } else {
            print("Unable to load PDF document")
            return
        }

        pdfViewController.view.addSubview(pdfView)

        // Configurar restricciones para PDFView
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: pdfViewController.view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: pdfViewController.view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: pdfViewController.view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pdfViewController.view.bottomAnchor)
        ])

        // Navegar al controlador PDFView
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
}
