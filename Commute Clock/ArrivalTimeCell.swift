//
//  ArrivalTimeCell.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class ArrivalTimeCell: UITableViewCell {

	@IBOutlet weak var arrivalTime: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateArrivalTime(timeString: String) {
        arrivalTime.text = timeString
    }

}
