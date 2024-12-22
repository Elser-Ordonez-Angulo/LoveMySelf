//
//  MindTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 22/11/24.
//

import UIKit

class MindTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mindImageView: UIImageView!
    

    
    @IBOutlet weak var tituloMindLabel: UILabel!
    
    
    @IBOutlet weak var tiempoMindLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
