//
//  DeportesTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 18/12/24.
//

import UIKit

class DeportesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoriadepLabel: UILabel!
    @IBOutlet weak var deporteCollectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
