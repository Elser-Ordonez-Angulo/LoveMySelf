//
//  RelajacionTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 22/11/24.
//

import UIKit

class RelajacionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var relajacionImageView: UIImageView!
    
    
    @IBOutlet weak var tituloLabel: UILabel!
    
    
    @IBOutlet weak var tiempoLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
