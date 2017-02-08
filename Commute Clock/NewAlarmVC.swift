//
//  NewAlarmVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit
import GooglePlaces

class NewAlarmVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DestinationMapVCDelegate {

	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var tableView: UITableView!
	
	var pickerTime: String = ""
    
    var arrivalTimeCell: ArrivalTimeCell?
    var destinationCell: DestinationCell?
    var prepTimeCell: PrepTimeCell?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
		tableView.dataSource = self
		
		timePicker.datePickerMode = .time
		timePicker.addTarget(self, action: #selector(NewAlarmVC.timePickerChanged(timePicker:)), for: .valueChanged)
		
    }
	
	
	/*
	*****************************
	UITableView Functions
	*****************************
	*/
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMap = ["ArrivalTimeCell", "DestinationCell", "PrepTimeCell"]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellMap[indexPath.row], for: indexPath)

        switch cell {
        case let cell as ArrivalTimeCell:
            cell.arrivalTime.text = pickerTime
            return cell
            
        case let cell as DestinationCell:
            return cell
            
        case let cell as PrepTimeCell:
            return cell
            
        default: break
        }
        return cell
        
	}
        
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1 {
			let destinationMapNav = self.storyboard?.instantiateViewController(withIdentifier: "DestinationMapNavVC") as! UINavigationController
            let destinationMapVC = destinationMapNav.viewControllers.first as! DestinationMapVC
            destinationMapVC.delegate = self
            
			self.present(destinationMapNav, animated: true, completion: nil)
        }
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 80
        } else {
            return UITableViewAutomaticDimension
        }
    }
	
	/*
	*****************************
	Time Picker Functions
	*****************************
	*/
	
	func timePickerChanged(timePicker: UIDatePicker) {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		dateFormatter.amSymbol = "AM"
		dateFormatter.pmSymbol = "PM"

		pickerTime = dateFormatter.string(from: timePicker.date)
		tableView.reloadData()
		
	}
    
    /*
     *****************************
     DestinationMapVCDelegate Functions
     *****************************
     */
    
    func acceptDestinationData(destination: GMSPlace!, transportation: TransportationType) {
        if let destinationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DestinationCell {
            destinationCell.updateDestinationCellText(location: destination.name)
            destinationCell.setSelectedTransportation(transportation: transportation)
        }
        
        
    }
	
	

}
