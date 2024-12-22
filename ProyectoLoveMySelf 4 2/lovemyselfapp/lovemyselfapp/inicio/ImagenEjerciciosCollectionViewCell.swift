//
//  ImagenEjerciciosCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class ImagenEjerciciosCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var ejerciciomagenView: UIImageView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           
           ejerciciomagenView.layer.cornerRadius = 30
           ejerciciomagenView.clipsToBounds = true
           
           // Agregar borde a la imagen
           ejerciciomagenView.layer.borderWidth = 2
           ejerciciomagenView.layer.borderColor = UIColor.black.cgColor
        
        
        ejerciciomagenView.contentMode = .scaleAspectFill
       }
    
}
