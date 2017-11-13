//
//  GuessNumberTableViewCell.swift
//  Lesson6-Practice2
//
//  Created by Chuang Boris on 12/11/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit

class GuessNumberTableViewCell: UITableViewCell {
    @IBOutlet weak var GuessNumberLabel: UILabel!
    
    @IBOutlet weak var GuessResultLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
