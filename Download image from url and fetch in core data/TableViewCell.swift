//
//  TableViewCell.swift
//  Download image from url and fetch in core data
//
//  Created by Developer Skromanglobal on 14/07/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Home_Image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
