//
//  PrepTimeCell.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/25/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class PrepTimeCell: UITableViewCell {

    @IBOutlet weak var prepTimeInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetCell() {
        prepTimeInput.text = ""
    }

}
