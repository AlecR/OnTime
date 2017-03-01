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
	@IBOutlet weak var destinationLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var transitImage: UIImageView!
	@IBOutlet weak var carImage: UIImageView!
	@IBOutlet weak var walkImage: UIImageView!
	@IBOutlet weak var prepTimeLabel: UILabel!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    var dayLabels = [UILabel]()
	

    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabels = [sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


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
    
    func updateActiveDayLabels(days: [Bool]) {
        for i in  0 ..< days.count {
            if days[i] == true {
                dayLabels[i].alpha = 1
            }
        }
    }
    
    func updateDestinationLabels(destinationName: String, destinationAddress: String) {
        destinationLabel.text = destinationName
        addressLabel.text = destinationAddress
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
    
    func updatePrepTimeLabel(prepTime: Int) {
        prepTimeLabel.text = "\(prepTime) minutes"
    }
    
    

}
