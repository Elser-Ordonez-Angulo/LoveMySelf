//
//  ComentariosTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 3/12/24.
//

import UIKit

class ComentariosTableViewCell: UITableViewCell {
    

    @IBOutlet weak var Apodo: UILabel!
    
    @IBOutlet weak var Experiencia: UILabel!
    
    @IBOutlet weak var Sugerencia: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
