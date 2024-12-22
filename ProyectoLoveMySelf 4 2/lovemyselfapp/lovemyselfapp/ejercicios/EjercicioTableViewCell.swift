//
//  EjercicioTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 25/10/24.
//

import UIKit

class EjercicioTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dificultadLabel: UILabel!
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var tiempoLabel: UILabel!
    
    @IBOutlet weak var masButton: UIButton!
    
    @IBOutlet weak var imageImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
