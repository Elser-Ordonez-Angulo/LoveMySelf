//
//  MusicaDetalleTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 3/12/24.
//

import UIKit

class MusicaDetalleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nombreCancionLabel: UILabel!
    @IBOutlet weak var imagenMusicaView: UIImageView!
    @IBOutlet weak var linkCancionLabel: UILabel!
    @IBOutlet weak var autorCancionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
