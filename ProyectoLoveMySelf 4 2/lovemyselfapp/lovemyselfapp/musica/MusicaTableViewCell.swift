//
//  MusicaTableViewCell.swift
//  lovemyselfapp
//
//  Created by DAMII on 12/12/24.
//

import UIKit

class MusicaTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var categoriaLabel: UILabel!
    
  
   
    @IBOutlet weak var musicaColectionView: UICollectionView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
