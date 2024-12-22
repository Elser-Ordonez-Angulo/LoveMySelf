//
//  MusicaCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 12/12/24.
//

import UIKit



class MusicaCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imagenImageView: UIImageView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var autorLabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
        
                imagenImageView.layer.cornerRadius = 10 // Ajusta el valor según lo desees
                imagenImageView.clipsToBounds = true 
                imagenImageView.contentMode = .scaleAspectFill
            
            // Hacer que la celda tenga bordes redondeados
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray.cgColor
        
        imagenImageView.contentMode = .scaleAspectFill
        }
    
    
    
}
