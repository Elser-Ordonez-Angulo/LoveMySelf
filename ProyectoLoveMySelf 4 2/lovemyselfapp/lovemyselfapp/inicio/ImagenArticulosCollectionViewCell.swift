//
//  ImagenArticulosCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class ImagenArticulosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articulosImageView: UIImageView!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
          
        articulosImageView.layer.cornerRadius = 30
        articulosImageView.clipsToBounds = true
           
           // Agregar borde a la imagen
        articulosImageView.layer.borderWidth = 2
        articulosImageView.layer.borderColor = UIColor.black.cgColor
        
        
        articulosImageView.contentMode = .scaleAspectFill
       }
}
