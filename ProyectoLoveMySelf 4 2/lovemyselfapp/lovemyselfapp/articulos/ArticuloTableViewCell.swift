//
//  ArticuloTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 25/10/24.
//

import UIKit

class ArticuloTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloArticuloLabel: UILabel!
    
    @IBOutlet weak var articuloImageView: UIImageView!
    
    @IBOutlet weak var fechaArticuloLabel: UILabel!
    
    @IBOutlet weak var autorArticuloLabel: UILabel!
    
    @IBOutlet weak var contenidoArticuloLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        /// Configuración para redondear solo las esquinas
        articuloImageView.layer.cornerRadius = 25 // Ajusta este valor según el nivel de redondeo deseado
        articuloImageView.layer.maskedCorners = [.layerMinXMinYCorner,  // Esquina superior izquierda
                                                 .layerMaxXMinYCorner,  // Esquina superior derecha
                                                 .layerMinXMaxYCorner,  // Esquina inferior izquierda
                                                 .layerMaxXMaxYCorner]  // Esquina inferior derecha
        articuloImageView.clipsToBounds = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
