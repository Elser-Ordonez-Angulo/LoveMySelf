//
//  DeportesCollectionViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class DeportesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deporteImageView: UIImageView!
    @IBOutlet weak var nombredepLabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            
            deporteImageView.layer.cornerRadius = 10
            deporteImageView.layer.masksToBounds = true
            
            // Agregar borde de color plomo (gris)
            deporteImageView.layer.borderColor = UIColor.darkGray.cgColor
            deporteImageView.layer.borderWidth = 2
        
        deporteImageView.contentMode = .scaleAspectFill

        }
    
}
