//
//  NewAlarmVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class NewAlarmVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var tableView: UITableView!
	
	var pickerTime: String = ""
	
	
	
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
		if indexPath.row == 0 {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalTimeCell") as? ArrivalTimeCell {
				cell.arrivalTime.text = pickerTime
				return cell
			}
		} else if indexPath.row == 1 {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell") as? DestinationCell {
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1 {
			let destinationMapNav = self.storyboard?.instantiateViewController(withIdentifier: "DestinationMapNavVC") as! UINavigationController
			self.present(destinationMapNav, animated: true, completion: nil)
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
		
		
		print(timePicker.date)
		pickerTime = dateFormatter.string(from: timePicker.date)
		tableView.reloadData()
		
	}
	
	

}
