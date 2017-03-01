//
//  DestinationCell.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class DestinationCell: UITableViewCell {
	
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var walkingImage: UIImageView!
    @IBOutlet weak var transitImage: UIImageView!
    
    @IBOutlet var transportationImages: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateDestinationCellText(location: String) {
        destinationLabel.text = location
    }
    
    func resetCell() {
        destinationLabel.text = ""
        for image in transportationImages {
            image.alpha = 0.3
        }
    }
    
    func setSelectedTransportation(transportation: TransportationType) {
        for image in transportationImages {
            image.alpha = 0.3
        }
        
        switch transportation {
        case .Car:
            carImage.alpha = 1
        case .Walking:
            walkingImage.alpha = 1
        case .Transit:
            transitImage.alpha = 1
        }
        
    }

}
