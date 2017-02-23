//
//  AlarmCell.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/12/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var amPmLabel: UILabel!
	@IBOutlet weak var repeatDaysLabel: UILabel!
	@IBOutlet weak var destinationLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var townLabel: UILabel!
	@IBOutlet weak var transitImage: UIImageView!
	@IBOutlet weak var carImage: UIImageView!
	@IBOutlet weak var walkImage: UIImageView!
	@IBOutlet weak var prepTimeLabel: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTransportationImages(transportationType: TransportationType) {
        switch transportationType {
        case .Car:
            carImage.layer.opacity = 1
        case .Walking:
            walkImage.layer.opacity = 1
        case .Transit:
            transitImage.layer.opacity = 1
        }
    }
    
    // Updates time labels
    // timeString format: HH:MM A
    func updateTimeLabels(timeString: String) {
        
        if(Helper.isTimeFormat(string: timeString)) {
            // Changes the amPmLabel to "PM" if the inputted string is a PM time (label's default is "AM")
            if timeString.substring(from: (timeString.range(of: " ")!.upperBound)) == "PM" {
                amPmLabel.text = "PM"
            }
            timeLabel.text = timeString.substring(to: (timeString.range(of: " ")!.lowerBound))
        }
        
    }
    
    

}
