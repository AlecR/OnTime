//
//  AlarmsVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/12/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AlarmsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
    
    var alarmData = [FIRDataSnapshot]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DataService.shared.CURRENT_USER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var alarms = [FIRDataSnapshot]()
            
            for data in snapshot.children {
                alarms.append(data as! FIRDataSnapshot)
            }
            
            // Sorts alarms by time (early to late)
            alarms.sort { $1.childSnapshot(forPath: "arrivalTime").value as! Int > $0.childSnapshot(forPath: "arrivalTime").value as! Int }

            
            self.alarmData = alarms
            self.tableView.reloadData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.displayAlarmCreated), name: Notification.Name.Names.DisplayCreatedAlarmMessage, object: nil)
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		return alarmData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell") as? AlarmCell {
            let data = alarmData[indexPath.row]
            
            // Resets the transportation picture indicators to default state
            cell.carImage.alpha = 0.4
            cell.walkImage.alpha = 0.4
            cell.transitImage.alpha = 0.4
            
            // Resets active days to default state
            for day in cell.dayLabels {
                day.alpha = 0.4
            }
            
            
            // Sets the time and AM/PM label of the cell
            if let arrivalTimeMinutes = data.childSnapshot(forPath: "arrivalTime").value as? Int {
                if let arrivalTimeString = Helper.minutesToTime(minutes: arrivalTimeMinutes) {
                    if let spaceIndex = arrivalTimeString.range(of: " ") {
                        let time = arrivalTimeString.substring(to: spaceIndex.lowerBound)
                        let amPm = arrivalTimeString.substring(from: spaceIndex.upperBound)
                        
                        cell.timeLabel.text = time
                        cell.amPmLabel.text = amPm
                    }
                }
            }
            
            if let activeDays = data.childSnapshot(forPath: "daysActive").value as? [Bool] {
                cell.updateActiveDayLabels(days: activeDays)
            }
            
            // Sets destination name label
            if let destinationName = data.childSnapshot(forPath: "location").childSnapshot(forPath: "name").value as? String {
                cell.destinationLabel.text = destinationName
            }
            
            // Sets destination address label
            if let destinationAddress = data.childSnapshot(forPath: "location").childSnapshot(forPath: "address").value as? String {
                cell.addressLabel.text = destinationAddress
            }
            
            // Sets the alpha to 1 for the image corresponding to selected transportation type
            if let transportation = data.childSnapshot(forPath: "transportation").value as? String {
                switch transportation {
                case "Car":
                    cell.carImage.alpha = 1
                case "Walking":
                    cell.walkImage.alpha = 1
                case "Transit":
                    cell.transitImage.alpha = 1
                default: break
                }
                
            }
            
            // Sets prep time label
            if let prepTime = data.childSnapshot(forPath: "prepTime").value as? Int {
                cell.prepTimeLabel.text = "\(prepTime) minutes"
            }

            return cell
        }
        
        return UITableViewCell()
	}
    
    
    // Displays a message notifying the user that the alarm was created
    func displayAlarmCreated() {
        if let alarmCreatedImage = UIImage(named: "AlarmCreatedMessage") {
            let imageView = UIImageView(image: alarmCreatedImage)
            let mainView = UIView(frame: CGRect(x: view.frame.size.width/2 - imageView.frame.width/2,
                                                 y: view.frame.size.height - 180,
                                                 width: alarmCreatedImage.size.width,
                                                 height: alarmCreatedImage.size.height))
            mainView.addSubview(imageView)
            view.addSubview(mainView)
            imageView.alpha = 0
            
            // Displays then hides the created alarm message
            UIView.animate(withDuration: 1.5, animations: {
                imageView.alpha = 1
            }, completion: { (completed) in
                if completed {
                    UIView.animate(withDuration: 1.5, animations: {
                        imageView.alpha = 0
                    }, completion: nil)
                }
            })
        }
        
    }
    

	

}
