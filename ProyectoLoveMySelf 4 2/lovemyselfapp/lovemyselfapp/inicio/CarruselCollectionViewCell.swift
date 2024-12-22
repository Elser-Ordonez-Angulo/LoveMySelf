//
//  CarruselCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class CarruselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carrucelImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Redondear las esquinas de la imagen
            carrucelImageView.layer.cornerRadius = 30  // Cambia el valor según el grado de redondeo que desees
            carrucelImageView.clipsToBounds = true  // Asegura que la imagen se recorte correctamente dentro de las esquinas redondeadas
            
            // Agregar borde a la imagen
            carrucelImageView.layer.borderWidth = 2  // Define el grosor del borde
            carrucelImageView.layer.borderColor = UIColor.black.cgColor  // Cambia el color del borde, puedes usar cualquier color que desees
            
           
            carrucelImageView.contentMode = .scaleAspectFill  
        }
    
}
