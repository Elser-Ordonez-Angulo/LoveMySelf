//
//  MusicgeneralTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 15/11/24.
//

import UIKit

class MusicgeneralTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var musicimg1ImageView: UIImageView!
    
    
    @IBOutlet weak var categoria1Label: UILabel!
    
    
    @IBOutlet weak var musicimg2ImageView: UIImageView!
    
    
    @IBOutlet weak var categoria2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
