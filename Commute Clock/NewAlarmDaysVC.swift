//
//  NewAlarmDaysVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 2/27/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

class NewAlarmDaysVC: UIViewController {
    
    var newAlarm: Alarm?
    var daysSelected = [false, false, false, false, false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dayButtonTapped(_ sender: UIButton) {
        if(sender.alpha != 1) {
            sender.alpha = 1
            daysSelected[sender.tag] = true
        } else {
            sender.alpha = 0.4
            daysSelected[sender.tag] = false
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: {
            let notificationName = Notification.Name("toHome")
            NotificationCenter.default.post(name: notificationName, object: nil)
        })
    }
    
    @IBAction func createAlarmPressed(_ sender: Any) {
        if let alarm = newAlarm {
            alarm.setActiveDays(days: daysSelected)
            DataService.shared.saveAlarmToDatabase(alarm: alarm)
            dismiss(animated: true, completion: {
                let notificationName = Notification.Name("toHome")
                NotificationCenter.default.post(name: notificationName, object: nil)
            })
        } else {
            displayAlert(title: "Error", message: "Unable to create alarm, try again.", buttonText: "Ok")
        }
        
    }
    

}
