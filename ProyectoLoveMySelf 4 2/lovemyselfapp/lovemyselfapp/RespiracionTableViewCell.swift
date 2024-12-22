//
//  RespiracionTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 21/11/24.
//

import UIKit

class RespiracionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Imagen1: UIImageView!
    
    @IBOutlet weak var Ejercicio: UILabel!
    
    @IBOutlet weak var Duracion: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
