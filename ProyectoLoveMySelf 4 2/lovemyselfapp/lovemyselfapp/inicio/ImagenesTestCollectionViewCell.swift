//
//  ImagenesTestCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class ImagenesTestCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var testImageview: UIImageView!
    
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
          
        testImageview.layer.cornerRadius = 30
        testImageview.clipsToBounds = true
           
           // Agregar borde a la imagen
        testImageview.layer.borderWidth = 2  // Define el grosor del borde
        testImageview.layer.borderColor = UIColor.black.cgColor
        
        testImageview.contentMode = .scaleAspectFill
       }
    
}
