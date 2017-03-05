//
//  NewAlarmVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/15/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseDatabase

class NewAlarmVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DestinationMapVCDelegate, UIGestureRecognizerDelegate {


	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
	
	var pickerTime: String = ""
    
    var selectedDestination: GMSPlace?
    var selectedTranspotation: TransportationType?
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(GradientHeaderView.instanceFromNib(title: "New Alarm"))
        
        tableView.delegate = self
		tableView.dataSource = self
		
		timePicker.datePickerMode = .time
		timePicker.addTarget(self, action: #selector(NewAlarmVC.timePickerChanged(timePicker:)), for: .valueChanged)
        
        // Sets intial value for ArrivalTimeCell
        timePickerChanged(timePicker: timePicker)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.toAlarms), name: Notification.Name.Names.ToAlarms, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let hideKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        view.addGestureRecognizer(hideKeyboardGesture)
        hideKeyboardGesture.delegate = self
		
    }
    
    deinit {
        NotificationCenter.default.removeObserver(Notification.Name.UIKeyboardWillShow)
        NotificationCenter.default.removeObserver(Notification.Name.UIKeyboardWillHide)
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
        
        if let arrivalTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ArrivalTimeCell {
            arrivalTimeCell.updateArrivalTime(timeString: pickerTime)
        }

		
	}
    
    
    
    /*
     *****************************
     DestinationMapVCDelegate Functions
     *****************************
     */
    
    func acceptDestinationData(destination: GMSPlace!, transportation: TransportationType) {
        selectedDestination = destination
        if let destinationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DestinationCell {
            destinationCell.updateDestinationCellText(location: destination.name)
            destinationCell.setSelectedTransportation(transportation: transportation)
            selectedTranspotation = transportation
        }
    }
	
    /*
     *****************************
     @IBAction Functionns
     *****************************
     */
    
    @IBAction func createAlarmPressed(_ sender: Any) {
        
        var arrivalTime: Int
        var location: GMSPlace
        
        if let arrivalTimeMinutes = Helper.timeToMinutes(selectedTime: pickerTime) {
            arrivalTime = arrivalTimeMinutes
            
            if selectedDestination == nil {
                let alert: UIAlertController = UIAlertController(title: "No Destiantion Selected", message: "Select a destination to continue.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {

                location = selectedDestination!
                if let prepTimeCellInput = ((tableView.cellForRow(at: IndexPath(row: 2, section: 0))) as? PrepTimeCell)?.prepTimeInput.text {
                    if let prepTime = Int(prepTimeCellInput) {
                        let newAlarm = Alarm(prepTime: prepTime, destination: location, arrivalTime: arrivalTime, transportationType: selectedTranspotation!.rawValue, activeDays: [])
                        performSegue(withIdentifier: "toNewAlarmDays", sender: newAlarm)
                    } else {
                        displayAlert(title: "Invalid Prep Time", message: "Invalid prep time inputted. Input a number to continue.", buttonText: "OK")
                    }
                } else {
                    displayAlert(title: "No Prep Time Inputted", message: "Input your prep time to continue.", buttonText: "OK")
                }
            }
        } else {
            displayAlert(title: "No Arrival Time Selected", message: "Select an arrival time to continue", buttonText: "OK")
        }
       
    }
    
    /*
     *****************************
     Segue Functions
     *****************************
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewAlarmDays" {
            if let destination = segue.destination as? NewAlarmDaysVC, let alarm = sender as? Alarm {
                destination.newAlarm = alarm
            }
        }
    }
    
    // Clears all inputs and goes to home tab. Used after an alarm is created.
    func toAlarms() {

        if let destinationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DestinationCell {
            destinationCell.resetCell()
        }
        if let prepTimeCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PrepTimeCell {
            prepTimeCell.resetCell()
        }
        
        
        selectedDestination = nil
        selectedTranspotation = nil
        timePicker.setDate(Date(), animated: false)
        timePickerChanged(timePicker: timePicker)
        
        
        tabBarController?.selectedIndex = 1
    }
    
    /*
     *****************************
     Keyboard Handling Functions
     *****************************
     */
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                if let frameHeight = endFrame?.size.height, let currentBottomSpacing = keyboardHeightLayoutConstraint?.constant {
                    self.keyboardHeightLayoutConstraint?.constant = frameHeight - currentBottomSpacing
                } else {
                    self.keyboardHeightLayoutConstraint?.constant = 0
                }
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func keyboardWillHide() {
        
        if let prepTimeCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PrepTimeCell {
            prepTimeCell.dismissKeyboard()
        }
        keyboardHeightLayoutConstraint?.constant = 47
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let tapView = touch.view {
            if tapView is DestinationCell || tapView.superview is DestinationCell {
                return false
            }
        }
        return true
        
    }

	
    
}
