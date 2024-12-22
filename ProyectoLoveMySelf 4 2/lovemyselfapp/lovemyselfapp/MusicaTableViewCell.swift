//
//  MusicaTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 14/11/24.
//

import UIKit

class MusicaTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var musicaImageView: UIImageView!
    
    
    @IBOutlet weak var nombreMusicaLabel: UILabel!
    
    
    @IBOutlet weak var autorMusicaLabel: UILabel!
    
    
    @IBOutlet weak var linkMusicaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
